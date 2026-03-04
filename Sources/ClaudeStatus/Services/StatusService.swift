import Foundation

actor StatusService {
    private let summaryURL = URL(string: "https://status.claude.com/api/v2/summary.json")!
    private let incidentsURL = URL(string: "https://status.claude.com/api/v2/incidents.json")!
    private let timeout: TimeInterval = 10

    private let cacheDir: URL
    private let summaryCacheFile: URL
    private let incidentsCacheFile: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        cacheDir = appSupport.appendingPathComponent("ClaudeStatus", isDirectory: true)
        summaryCacheFile = cacheDir.appendingPathComponent("summary_cache.json")
        incidentsCacheFile = cacheDir.appendingPathComponent("incidents_cache.json")

        try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
    }

    struct FetchResult: Sendable {
        let summary: SummaryResponse?
        let incidents: IncidentsResponse?
        let isOnline: Bool
    }

    func fetch() async -> FetchResult {
        // Parallel fetch
        async let summaryTask = fetchAndDecode(
            url: summaryURL,
            cacheFile: summaryCacheFile,
            as: SummaryResponse.self
        )
        async let incidentsTask = fetchAndDecode(
            url: incidentsURL,
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

    private struct DecodeResult<T: Sendable>: Sendable {
        let value: T?
        let online: Bool
    }

    private func fetchAndDecode<T: Decodable & Sendable>(
        url: URL,
        cacheFile: URL,
        as type: T.Type
    ) async -> DecodeResult<T> {
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = timeout
            let (data, response) = try await URLSession.shared.data(for: request)

            // Validate HTTP status code
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                let cached = loadCache(file: cacheFile, as: type)
                return DecodeResult(value: cached, online: false)
            }

            let decoded = try JSONDecoder().decode(type, from: data)
            try? data.write(to: cacheFile, options: .atomic)
            return DecodeResult(value: decoded, online: true)
        } catch {
            let cached = loadCache(file: cacheFile, as: type)
            return DecodeResult(value: cached, online: false)
        }
    }

    private let cacheMaxAge: TimeInterval = 3600 // 1 hour

    private func loadCache<T: Decodable>(file: URL, as type: T.Type) -> T? {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: file.path),
              let modified = attrs[.modificationDate] as? Date,
              Date().timeIntervalSince(modified) < cacheMaxAge,
              let data = try? Data(contentsOf: file) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
