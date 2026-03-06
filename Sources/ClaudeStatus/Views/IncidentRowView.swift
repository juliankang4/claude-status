import SwiftUI

struct IncidentRowView: View {
    let incident: Incident
    let language: AppLanguage
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header row (clickable to expand/collapse)
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .top, spacing: 6) {
                    Text(isExpanded ? "▼" : "▶")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .frame(width: 10, alignment: .center)
                        .padding(.top, 2)

                    Text("[\(L10n.incidentLabel(incident.status, language: language))]")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(StatusMapping.incidentColor(for: incident.status))

                    Text(L10n.translateIncidentName(incident.name, language: language))
                        .font(.system(size: 11))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)

                    Spacer()

                    // Duration for ongoing, date for resolved
                    if incident.resolvedAt == nil,
                       let dur = DateFormatting.duration(from: incident.startedAt, to: nil, language: language) {
                        Text(dur)
                            .font(.system(size: 10))
                            .foregroundStyle(.orange)
                    } else {
                        Text(DateFormatting.shortDate(incident.createdAt))
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())

            // Expanded detail
            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    // Show resolved duration if applicable
                    if let resolvedAt = incident.resolvedAt,
                       let resolvedDate = DateFormatting.parseISO(resolvedAt),
                       let dur = DateFormatting.duration(
                           from: incident.startedAt,
                           to: resolvedDate,
                           language: language
                       ) {
                        Text(L10n.get(.duration, language: language) + ": " + dur)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }

                    // Incident updates
                    ForEach(incident.incidentUpdates.prefix(3), id: \.id) { update in
                        VStack(alignment: .leading, spacing: 2) {
                            Text("[\(L10n.incidentLabel(update.status, language: language))]")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(StatusMapping.incidentColor(for: update.status))

                            Text(HTMLText.plain(update.body))
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                                .lineLimit(4)
                        }
                    }

                    // Browser link
                    Button {
                        AppConstants.openIfAllowed(incident.shortlink)
                    } label: {
                        HStack(spacing: 4) {
                            Text("🔗")
                                .font(.system(size: 10))
                            Text(L10n.get(.openInBrowser, language: language))
                                .font(.system(size: 10))
                                .foregroundStyle(.blue)
                        }
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                    }
                }
                .padding(.leading, 16)
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 2)
    }
}
