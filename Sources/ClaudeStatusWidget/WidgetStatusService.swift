import Foundation
import ClaudeStatusShared

struct WidgetFetchResult: Sendable {
    let summary: SummaryResponse?
    let incidents: IncidentsResponse?
}

enum WidgetStatusService {
    static func fetch() async -> WidgetFetchResult {
        async let summaryTask = fetchJSON(
            url: SharedConstants.summaryURL,
            as: SummaryResponse.self
        )
        async let incidentsTask = fetchJSON(
            url: SharedConstants.incidentsURL,
            as: IncidentsResponse.self
        )

        let (summary, incidents) = await (summaryTask, incidentsTask)
        return WidgetFetchResult(summary: summary, incidents: incidents)
    }

    private static func fetchJSON<T: Decodable & Sendable>(
        url: URL,
        as type: T.Type
    ) async -> T? {
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = SharedConstants.apiTimeout
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode) else {
                return nil
            }

            return try JSONDecoder().decode(type, from: data)
        } catch {
            return nil
        }
    }
}
