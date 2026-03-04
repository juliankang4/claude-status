import SwiftUI

struct IncidentSectionView: View {
    let incidents: [Incident]
    let language: AppLanguage

    @State private var expandedIDs: Set<String> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("📋")
                Text(L10n.get(.recentIncidents, language: language))
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.bottom, 2)

            if incidents.isEmpty {
                Text(L10n.get(.noIncidents, language: language))
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(incidents) { incident in
                    IncidentRowView(
                        incident: incident,
                        language: language,
                        isExpanded: Binding(
                            get: { expandedIDs.contains(incident.id) },
                            set: { newValue in
                                if newValue {
                                    expandedIDs.insert(incident.id)
                                } else {
                                    expandedIDs.remove(incident.id)
                                }
                            }
                        )
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
