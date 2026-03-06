import Foundation
import AppKit

enum AppConstants {
    // MARK: - API
    static let summaryURL = URL(string: "https://status.claude.com/api/v2/summary.json")!
    static let incidentsURL = URL(string: "https://status.claude.com/api/v2/incidents.json")!
    static let apiTimeout: TimeInterval = 10

    // MARK: - Cache
    static let cacheDirectoryName = "ClaudeStatus"
    static let summaryCacheFileName = "summary_cache.json"
    static let incidentsCacheFileName = "incidents_cache.json"
    static let cacheMaxAge: TimeInterval = 3600 // 1 hour

    // MARK: - Refresh
    static let defaultRefreshInterval: TimeInterval = 15
    static let refreshIntervalOptions: [TimeInterval] = [15, 30, 60, 300]

    // MARK: - Display
    static let maxRecentIncidents = 5
    static let uptimeDays = 30

    // MARK: - GitHub
    static let githubRepo = "juliankang4/claude-status"
    static let currentVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    static let releasesAPIURL = URL(string: "https://api.github.com/repos/juliankang4/claude-status/releases/latest")!

    // MARK: - Keyboard Shortcut
    static let hotkeyKeyCode: UInt16 = 8 // 'C' key

    // MARK: - Allowed External Hosts
    static let allowedHosts: Set<String> = [
        "status.claude.com", "stspg.io", "github.com", "www.github.com"
    ]
    static let redirectValidationHosts: Set<String> = [
        "stspg.io"
    ]

    static func openIfAllowed(_ raw: String) {
        Task {
            guard let url = await validatedURL(from: raw) else { return }
            await MainActor.run {
                _ = NSWorkspace.shared.open(url)
            }
        }
    }

    private static func validatedURL(from raw: String) async -> URL? {
        guard let url = URL(string: raw), isAllowed(url) else { return nil }
        guard shouldValidateRedirect(for: url) else { return url }
        guard let finalURL = await resolveFinalURL(for: url), isAllowed(finalURL) else { return nil }
        return finalURL
    }

    private static func resolveFinalURL(for url: URL) async -> URL? {
        if let resolved = await resolveFinalURL(for: url, method: "HEAD") {
            return resolved
        }
        return await resolveFinalURL(for: url, method: "GET")
    }

    private static func resolveFinalURL(for url: URL, method: String) async -> URL? {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = apiTimeout
        request.cachePolicy = .reloadIgnoringLocalCacheData

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return response.url
        } catch {
            return nil
        }
    }

    private static func shouldValidateRedirect(for url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return redirectValidationHosts.contains(where: { host == $0 || host.hasSuffix(".\($0)") })
    }

    private static func isAllowed(_ url: URL) -> Bool {
        guard url.scheme?.lowercased() == "https",
              let host = url.host?.lowercased() else {
            return false
        }

        return allowedHosts.contains(where: { host == $0 || host.hasSuffix(".\($0)") })
    }
}
