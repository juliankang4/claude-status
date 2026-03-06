import Foundation
import OSLog

actor StatusService {
    private let logger = Logger(subsystem: "com.julianyoon.claude-status", category: "StatusService")

    private let cacheDir: URL
    private let summaryCacheFile: URL
    private let incidentsCacheFile: URL

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        cacheDir = appSupport.appendingPathComponent(AppConstants.cacheDirectoryName, isDirectory: true)
        summaryCacheFile = cacheDir.appendingPathComponent(AppConstants.summaryCacheFileName)
        incidentsCacheFile = cacheDir.appendingPathComponent(AppConstants.incidentsCacheFileName)

        do {
            try FileManager.default.createDirectory(
                at: cacheDir,
                withIntermediateDirectories: true,
                attributes: [.posixPermissions: 0o700]
            )
            try FileManager.default.setAttributes(
                [.posixPermissions: 0o700],
                ofItemAtPath: cacheDir.path
            )
        } catch {
            logger.error("Cache permission setup failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    struct FetchResult: Sendable {
        let summary: SummaryResponse?
        let incidents: IncidentsResponse?
        let isOnline: Bool
    }

    func fetch() async -> FetchResult {
        async let summaryTask = fetchAndDecode(
            url: AppConstants.summaryURL,
            cacheFile: summaryCacheFile,
            as: SummaryResponse.self
        )
        async let incidentsTask = fetchAndDecode(
            url: AppConstants.incidentsURL,
            cacheFile: incidentsCacheFile,
            as: IncidentsResponse.self
        )

        let (summaryResult, incidentsResult) = await (summaryTask, incidentsTask)

        return FetchResult(
            summary: summaryResult.value,
            incidents: incidentsResult.value,
            isOnline: summaryResult.online && incidentsResult.online
        )
    }

    func loadCachedSnapshot() -> FetchResult {
        FetchResult(
            summary: loadCache(file: summaryCacheFile, as: SummaryResponse.self),
            incidents: loadCache(file: incidentsCacheFile, as: IncidentsResponse.self),
            isOnline: false
        )
    }

    // MARK: - Uptime Calculation (off main thread)

    func buildUptimeCache(
        components: [Component],
        incidents: [Incident]
    ) -> [String: [DayStatus]] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let today = calendar.startOfDay(for: Date())
        var cache: [String: [DayStatus]] = [:]
        let incidentWindowsByComponent = indexIncidentWindows(incidents)

        for component in components {
            let startDate = component.startDate.flatMap { dateFormatter.date(from: $0) }
            let windows = incidentWindowsByComponent[component.id] ?? []

            let data: [DayStatus] = (0..<AppConstants.uptimeDays).reversed().map { daysAgo in
                let day = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
                let dayStr = dateFormatter.string(from: day)

                if let start = startDate, day < start {
                    return DayStatus(date: day, status: .noData)
                }

                return DayStatus(date: day, status: uptimeStatus(for: dayStr, windows: windows))
            }
            cache[component.id] = data
        }

        return cache
    }

    // MARK: - Update Check

    struct LatestRelease: Sendable {
        let version: String
        let url: String
    }

    func checkForUpdate() async -> LatestRelease? {
        do {
            var request = URLRequest(url: AppConstants.releasesAPIURL)
            request.timeoutInterval = AppConstants.apiTimeout
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                logger.warning("Update check failed: bad HTTP status")
                return nil
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let tagName = json["tag_name"] as? String,
                  let htmlURL = json["html_url"] as? String else {
                return nil
            }

            let version = tagName.hasPrefix("v") ? String(tagName.dropFirst()) : tagName
            guard isNewer(version, than: AppConstants.currentVersion) else { return nil }

            logger.info("New version available: \(version)")
            return LatestRelease(version: version, url: htmlURL)
        } catch {
            logger.warning("Update check error: \(error.localizedDescription)")
            return nil
        }
    }

    private func isNewer(_ remote: String, than local: String) -> Bool {
        let r = remote.split(separator: ".").compactMap { Int($0) }
        let l = local.split(separator: ".").compactMap { Int($0) }
        for i in 0..<max(r.count, l.count) {
            let rv = i < r.count ? r[i] : 0
            let lv = i < l.count ? l[i] : 0
            if rv > lv { return true }
            if rv < lv { return false }
        }
        return false
    }

    // MARK: - Private

    private struct DecodeResult<T: Sendable>: Sendable {
        let value: T?
        let online: Bool
    }

    private struct IncidentWindow: Sendable {
        let startDay: String
        let endDay: String
        let impact: IncidentImpact
    }

    private func fetchAndDecode<T: Decodable & Sendable>(
        url: URL,
        cacheFile: URL,
        as type: T.Type
    ) async -> DecodeResult<T> {
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = AppConstants.apiTimeout
            let (data, response) = try await URLSession.shared.data(for: request)

            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                logger.warning("HTTP \(http.statusCode) for \(url.lastPathComponent)")
                let cached = loadCache(file: cacheFile, as: type)
                return DecodeResult(value: cached, online: false)
            }

            let decoded = try JSONDecoder().decode(type, from: data)
            try? data.write(to: cacheFile, options: .atomic)
            return DecodeResult(value: decoded, online: true)
        } catch {
            logger.error("Fetch failed for \(url.lastPathComponent): \(error.localizedDescription)")
            let cached = loadCache(file: cacheFile, as: type)
            return DecodeResult(value: cached, online: false)
        }
    }

    private func loadCache<T: Decodable>(file: URL, as type: T.Type) -> T? {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: file.path),
              let modified = attrs[.modificationDate] as? Date,
              Date().timeIntervalSince(modified) < AppConstants.cacheMaxAge,
              let data = try? Data(contentsOf: file) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private func indexIncidentWindows(_ incidents: [Incident]) -> [String: [IncidentWindow]] {
        var index: [String: [IncidentWindow]] = [:]

        for incident in incidents {
            let window = IncidentWindow(
                startDay: String(incident.startedAt.prefix(10)),
                endDay: String((incident.resolvedAt ?? "9999-12-31").prefix(10)),
                impact: incident.impact
            )

            let componentIDs = Set(
                incident.incidentUpdates.flatMap { update in
                    (update.affectedComponents ?? []).map(\.code)
                }
            )

            for componentID in componentIDs {
                index[componentID, default: []].append(window)
            }
        }

        return index
    }

    private func uptimeStatus(for day: String, windows: [IncidentWindow]) -> UptimeStatus {
        var hasIncident = false

        for window in windows where day >= window.startDay && day <= window.endDay {
            hasIncident = true
            if window.impact == .major || window.impact == .critical {
                return .major
            }
        }

        return hasIncident ? .minor : .operational
    }
}
