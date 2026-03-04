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
        let session = URLSession.shared
        var summary: SummaryResponse?
        var incidents: IncidentsResponse?
        var online = true

        // Fetch summary
        do {
            var request = URLRequest(url: summaryURL)
            request.timeoutInterval = timeout
            let (data, _) = try await session.data(for: request)
            summary = try JSONDecoder().decode(SummaryResponse.self, from: data)
            try? data.write(to: summaryCacheFile)
        } catch {
            online = false
            summary = loadCache(file: summaryCacheFile, as: SummaryResponse.self)
        }

        // Fetch incidents
        do {
            var request = URLRequest(url: incidentsURL)
            request.timeoutInterval = timeout
            let (data, _) = try await session.data(for: request)
            incidents = try JSONDecoder().decode(IncidentsResponse.self, from: data)
            try? data.write(to: incidentsCacheFile)
        } catch {
            incidents = loadCache(file: incidentsCacheFile, as: IncidentsResponse.self)
        }

        return FetchResult(summary: summary, incidents: incidents, isOnline: online)
    }

    private func loadCache<T: Decodable>(file: URL, as type: T.Type) -> T? {
        guard let data = try? Data(contentsOf: file) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
