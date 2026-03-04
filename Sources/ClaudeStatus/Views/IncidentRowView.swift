import SwiftUI

struct IncidentRowView: View {
    let incident: Incident
    let language: AppLanguage

    var body: some View {
        Button {
            if let url = URL(string: incident.shortlink) {
                NSWorkspace.shared.open(url)
            }
        } label: {
            HStack(alignment: .top, spacing: 6) {
                Text("[\(L10n.incidentLabel(incident.status, language: language))]")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(StatusMapping.incidentColor(for: incident.status))

                Text(L10n.translateIncidentName(incident.name, language: language))
                    .font(.system(size: 11))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)

                Spacer()

                Text(DateFormatting.shortDate(incident.createdAt))
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .onHover { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        }
    }
}
