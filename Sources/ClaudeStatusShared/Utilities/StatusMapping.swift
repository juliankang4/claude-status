import SwiftUI

package enum StatusMapping {
    package static func icon(for status: ComponentStatus) -> String {
        switch status {
        case .operational: "✅"
        case .degradedPerformance: "⚠️"
        case .partialOutage: "🟠"
        case .majorOutage: "❌"
        case .unknown: "❓"
        }
    }

    package static func color(for status: ComponentStatus) -> Color {
        switch status {
        case .operational: .green
        case .degradedPerformance: .orange
        case .partialOutage: Color(red: 1.0, green: 0.4, blue: 0.0)
        case .majorOutage: .red
        case .unknown: .gray
        }
    }

    package static func incidentColor(for status: IncidentStatus) -> Color {
        switch status {
        case .resolved, .postmortem: .green
        case .monitoring, .identified: .orange
        case .investigating: .red
        case .unknown: .gray
        }
    }
}
