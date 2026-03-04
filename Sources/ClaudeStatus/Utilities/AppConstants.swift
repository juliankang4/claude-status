import Foundation

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
    static let currentVersion = "0.0.5"
    static let releasesAPIURL = URL(string: "https://api.github.com/repos/juliankang4/claude-status/releases/latest")!

    // MARK: - Keyboard Shortcut
    static let hotkeyKeyCode: UInt16 = 8 // 'C' key
}
