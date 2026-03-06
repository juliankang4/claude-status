import SwiftUI
import WidgetKit
import ClaudeStatusShared

struct SmallWidgetView: View {
    let entry: StatusEntry

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: iconName)
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(WidgetColors.indicatorColor(for: entry.indicator))
                .shadow(color: WidgetColors.indicatorColor(for: entry.indicator).opacity(0.4), radius: 6)

            Text(WidgetLabels.overallStatus(for: entry.indicator, language: entry.language))
                .font(.system(size: 15, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text("Claude")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(WidgetColors.brand)
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
