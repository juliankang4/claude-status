import SwiftUI
import WidgetKit
import ClaudeStatusShared

struct MediumWidgetView: View {
    let entry: StatusEntry

    var body: some View {
        HStack(spacing: 12) {
            // Left: Overall status
            VStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(WidgetColors.indicatorColor(for: entry.indicator))

                Text(WidgetLabels.overallStatus(for: entry.indicator, language: entry.language))
                    .font(.system(size: 11, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text("Claude")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)

            Divider()

            // Right: Service list
            VStack(alignment: .leading, spacing: 3) {
                if entry.components.isEmpty {
                    Text(entry.language == .korean ? "데이터 없음" : "No data")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(entry.components.prefix(5)) { component in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(WidgetColors.componentColor(for: component.status))
                                .frame(width: 6, height: 6)
                            Text(component.displayName)
                                .font(.system(size: 10))
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 4)
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
