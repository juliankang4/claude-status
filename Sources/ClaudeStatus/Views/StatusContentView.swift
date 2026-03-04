import SwiftUI

struct StatusContentView: View {
    let monitor: StatusMonitor
    let settings: AppSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            Text(L10n.get(.title, language: settings.language))
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 8)

            Divider()

            // Components
            if monitor.components.isEmpty {
                Text(L10n.get(.noData, language: settings.language))
                    .foregroundStyle(.red)
                    .font(.system(size: 12))
                    .padding(16)
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(monitor.components) { component in
                        ServiceRowView(
                            component: component,
                            language: settings.language,
                            uptimeData: monitor.uptimeData(for: component)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }

            Divider()

            // Incidents
            IncidentSectionView(
                incidents: monitor.recentIncidents,
                language: settings.language
            )

            Divider()

            // Footer
            FooterView(
                isOnline: monitor.isOnline,
                lastRefresh: monitor.lastRefresh,
                language: settings.language,
                onRefresh: { Task { await monitor.refresh() } }
            )

            Divider()

            // Settings
            SettingsSectionView(settings: settings, monitor: monitor)
        }
        .frame(width: 340)
    }
}
