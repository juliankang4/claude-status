import SwiftUI
import WidgetKit
import ClaudeStatusShared

struct SmallWidgetView: View {
    let entry: StatusEntry

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(WidgetColors.indicatorColor(for: entry.indicator))

            Text(WidgetLabels.overallStatus(for: entry.indicator, language: entry.language))
                .font(.system(size: 12, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("Claude")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .widgetURL(URL(string: "https://status.claude.com"))
    }

    private var iconName: String {
        switch entry.indicator {
        case .none: "checkmark.circle.fill"
        case .minor: "exclamationmark.triangle.fill"
        case .major: "exclamationmark.circle.fill"
        case .critical: "xmark.circle.fill"
        case .unknown: "questionmark.circle.fill"
        }
    }
}
