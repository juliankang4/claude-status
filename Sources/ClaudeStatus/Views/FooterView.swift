import SwiftUI
import ClaudeStatusShared

struct FooterView: View {
    let isOnline: Bool
    let lastRefresh: Date?
    let language: AppLanguage
    let onRefresh: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Status time
            if isOnline {
                let checked = lastRefresh.map { DateFormatting.time($0, language: language) } ?? "-"
                Text("\(L10n.get(.lastChecked, language: language)): \(checked)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            } else {
                HStack(spacing: 4) {
                    Text("⚠️")
                    let checked = lastRefresh.map { DateFormatting.time($0, language: language) } ?? "-"
                    Text("\(L10n.get(.offline, language: language)) — \(checked)")
                        .font(.system(size: 11))
                        .foregroundStyle(.orange)
                }
            }

            HStack(spacing: 12) {
                // Open status page
                Button {
                    AppConstants.openIfAllowed("https://status.claude.com")
                } label: {
                    HStack(spacing: 4) {
                        Text("🌐")
                        Text(L10n.get(.openStatusPage, language: language))
                            .font(.system(size: 11))
                    }
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }

                Spacer()

                // Refresh
                Button {
                    onRefresh()
                } label: {
                    HStack(spacing: 4) {
                        Text("🔄")
                        Text(L10n.get(.refresh, language: language))
                            .font(.system(size: 11))
                    }
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
