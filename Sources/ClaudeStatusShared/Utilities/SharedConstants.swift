import Foundation

package enum SharedConstants {
    // MARK: - API
    package static let summaryURL = URL(string: "https://status.claude.com/api/v2/summary.json")!
    package static let incidentsURL = URL(string: "https://status.claude.com/api/v2/incidents.json")!
    package static let apiTimeout: TimeInterval = 10

    // MARK: - Display
    package static let maxRecentIncidents = 5
    package static let uptimeDays = 30
}
