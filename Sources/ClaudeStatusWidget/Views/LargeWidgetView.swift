import SwiftUI
import WidgetKit
import ClaudeStatusShared

struct LargeWidgetView: View {
    let entry: StatusEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header — status banner
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(WidgetColors.indicatorColor(for: entry.indicator))

                VStack(alignment: .leading, spacing: 2) {
                    Text(WidgetLabels.overallStatus(for: entry.indicator, language: entry.language))
                        .font(.system(size: 16, weight: .bold))
                    Text("Claude")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(WidgetColors.brand)
                }

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(WidgetColors.statusBackground(for: entry.indicator))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer().frame(height: 14)

            // Services
            if entry.components.isEmpty {
                Text(entry.language == .korean ? "데이터 없음" : "No data")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(entry.components.prefix(6)) { component in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(WidgetColors.componentColor(for: component.status))
                                .frame(width: 9, height: 9)
                            Text(component.displayName)
                                .font(.system(size: 14, weight: .medium))
                                .lineLimit(1)
                            Spacer()
                            Text(L10n.statusLabel(component.status, language: entry.language))
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            // Recent incidents
            if !entry.recentIncidents.isEmpty {
                Spacer().frame(height: 14)

                // Section divider
                RoundedRectangle(cornerRadius: 1)
                    .fill(.quaternary)
                    .frame(height: 1)

                Spacer().frame(height: 10)

                Text(L10n.get(.recentIncidents, language: entry.language))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)

                Spacer().frame(height: 8)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(entry.recentIncidents.prefix(3)) { incident in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(incidentColor(for: incident.impact))
                                .frame(width: 7, height: 7)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(L10n.translateIncidentName(incident.name, language: entry.language))
                                    .font(.system(size: 13, weight: .medium))
                                    .lineLimit(1)
                                Text(DateFormatting.shortDate(incident.startedAt))
                                    .font(.system(size: 11))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(L10n.incidentLabel(incident.status, language: entry.language))
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(incidentStatusColor(for: incident.status))
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

    private func incidentStatusColor(for status: IncidentStatus) -> Color {
        switch status {
        case .resolved, .postmortem: .green
        case .monitoring, .identified: .orange
        case .investigating: .red
        case .unknown: .secondary
        }
    }
}
