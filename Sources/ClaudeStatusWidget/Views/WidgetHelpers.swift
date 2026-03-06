import SwiftUI
import ClaudeStatusShared

enum WidgetColors {
    // Claude brand color
    static let brand = Color(red: 0.85, green: 0.47, blue: 0.34) // #D97757

    static func indicatorColor(for indicator: StatusIndicator) -> Color {
        switch indicator {
        case .none: .green
        case .minor: .orange
        case .major: Color(red: 1.0, green: 0.4, blue: 0.0)
        case .critical: .red
        case .unknown: .gray
        }
    }

    static func componentColor(for status: ComponentStatus) -> Color {
        StatusMapping.color(for: status)
    }

    static func statusBackground(for indicator: StatusIndicator) -> Color {
        switch indicator {
        case .none: .green.opacity(0.12)
        case .minor: .orange.opacity(0.12)
        case .major: Color(red: 1.0, green: 0.4, blue: 0.0).opacity(0.12)
        case .critical: .red.opacity(0.12)
        case .unknown: .gray.opacity(0.12)
        }
    }
}

enum WidgetLabels {
    static func overallStatus(for indicator: StatusIndicator, language: AppLanguage) -> String {
        switch language {
        case .korean:
            switch indicator {
            case .none: "정상"
            case .minor: "일부 문제"
            case .major: "장애 발생"
            case .critical: "심각한 장애"
            case .unknown: "확인 불가"
            }
        case .english:
            switch indicator {
            case .none: "All Systems Operational"
            case .minor: "Minor Issues"
            case .major: "Major Outage"
            case .critical: "Critical Outage"
            case .unknown: "Unable to Connect"
            }
        }
    }

    static func statusDot(for status: ComponentStatus) -> String {
        StatusMapping.icon(for: status)
    }
}
