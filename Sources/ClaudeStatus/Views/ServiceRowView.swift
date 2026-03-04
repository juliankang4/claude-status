import SwiftUI

struct ServiceRowView: View {
    let component: Component
    let language: AppLanguage
    let uptimeData: [DayStatus]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(StatusMapping.icon(for: component.status))
                    .font(.system(size: 13))

                Text(component.displayName)
                    .font(.system(size: 12, design: .monospaced))
                    .lineLimit(1)

                Spacer()

                Text(L10n.statusLabel(component.status, language: language))
                    .font(.system(size: 11))
                    .foregroundStyle(StatusMapping.color(for: component.status))
            }

            // Uptime bar
            if !uptimeData.isEmpty {
                UptimeBarView(
                    data: uptimeData,
                    label: L10n.get(.thirtyDays, language: language),
                    language: language
                )
            }
        }
        .padding(.vertical, 2)
    }
}
