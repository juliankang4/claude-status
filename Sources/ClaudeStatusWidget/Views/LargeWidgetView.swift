import SwiftUI
import WidgetKit
import ClaudeStatusShared

struct LargeWidgetView: View {
    let entry: StatusEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(WidgetColors.indicatorColor(for: entry.indicator))

                Text(WidgetLabels.overallStatus(for: entry.indicator, language: entry.language))
                    .font(.system(size: 13, weight: .semibold))

                Spacer()

                Text("Claude")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }

            Divider()

            // Services
            if entry.components.isEmpty {
                Text(entry.language == .korean ? "데이터 없음" : "No data")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(entry.components.prefix(6)) { component in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(WidgetColors.componentColor(for: component.status))
                                .frame(width: 7, height: 7)
                            Text(component.displayName)
                                .font(.system(size: 11))
                                .lineLimit(1)
                            Spacer()
                            Text(L10n.statusLabel(component.status, language: entry.language))
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            // Recent incidents
            if !entry.recentIncidents.isEmpty {
                Divider()

                Text(L10n.get(.recentIncidents, language: entry.language))
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(entry.recentIncidents.prefix(3)) { incident in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(incidentColor(for: incident.impact))
                                .frame(width: 6, height: 6)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(L10n.translateIncidentName(incident.name, language: entry.language))
                                    .font(.system(size: 10))
                                    .lineLimit(1)
                                Text(DateFormatting.shortDate(incident.startedAt))
                                    .font(.system(size: 9))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(L10n.incidentLabel(incident.status, language: entry.language))
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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

    private func incidentColor(for impact: IncidentImpact) -> Color {
        switch impact {
        case .none: .green
        case .minor: .orange
        case .major: Color(red: 1.0, green: 0.4, blue: 0.0)
        case .critical: .red
        case .unknown: .gray
        }
    }
}
