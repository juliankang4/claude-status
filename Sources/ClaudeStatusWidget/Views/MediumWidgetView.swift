import SwiftUI
import WidgetKit
import ClaudeStatusShared

struct MediumWidgetView: View {
    let entry: StatusEntry

    var body: some View {
        HStack(spacing: 14) {
            // Left: Overall status
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(WidgetColors.indicatorColor(for: entry.indicator))
                    .shadow(color: WidgetColors.indicatorColor(for: entry.indicator).opacity(0.4), radius: 6)

                Text(WidgetLabels.overallStatus(for: entry.indicator, language: entry.language))
                    .font(.system(size: 13, weight: .bold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text("Claude")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(WidgetColors.brand)
            }
            .frame(maxWidth: .infinity)

            // Vertical separator
            RoundedRectangle(cornerRadius: 1)
                .fill(.quaternary)
                .frame(width: 1)
                .padding(.vertical, 4)

            // Right: Service list
            VStack(alignment: .leading, spacing: 5) {
                if entry.components.isEmpty {
                    Text(entry.language == .korean ? "데이터 없음" : "No data")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(entry.components.prefix(5)) { component in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(WidgetColors.componentColor(for: component.status))
                                .frame(width: 8, height: 8)
                            Text(component.displayName)
                                .font(.system(size: 12, weight: .medium))
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
