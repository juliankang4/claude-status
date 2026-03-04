import SwiftUI
import ServiceManagement

struct SettingsSectionView: View {
    @Bindable var settings: AppSettings

    @State private var loginItemEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("⚙️")
                Text(L10n.get(.settings, language: settings.language))
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.bottom, 2)

            // Notifications toggle
            Toggle(isOn: $settings.notificationsEnabled) {
                HStack(spacing: 4) {
                    Text(settings.notificationsEnabled ? "🔔" : "🔕")
                    Text(settings.notificationsEnabled
                        ? L10n.get(.notificationsOn, language: settings.language)
                        : L10n.get(.notificationsOff, language: settings.language))
                        .font(.system(size: 11))
                }
            }
            .toggleStyle(.switch)
            .controlSize(.mini)

            // Launch at login toggle
            Toggle(isOn: $loginItemEnabled) {
                HStack(spacing: 4) {
                    Text("🚀")
                    Text(loginItemEnabled
                        ? L10n.get(.launchAtLoginOn, language: settings.language)
                        : L10n.get(.launchAtLoginOff, language: settings.language))
                        .font(.system(size: 11))
                }
            }
            .toggleStyle(.switch)
            .controlSize(.mini)
            .onChange(of: loginItemEnabled) { _, newValue in
                updateLoginItem(enabled: newValue)
            }

            // Language
            HStack(spacing: 8) {
                Text("🌐")
                Text(L10n.get(.language, language: settings.language))
                    .font(.system(size: 11))
                Spacer()
                Picker("", selection: $settings.language) {
                    Text("English").tag(AppLanguage.english)
                    Text("한국어").tag(AppLanguage.korean)
                }
                .pickerStyle(.segmented)
                .frame(width: 140)
            }

            // Quit
            Divider()
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text(L10n.get(.quit, language: settings.language))
                    .font(.system(size: 11))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                if hovering { NSCursor.pointingHand.set() } else { NSCursor.arrow.set() }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .onAppear {
            loginItemEnabled = SMAppService.mainApp.status == .enabled
        }
    }

    private func updateLoginItem(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // Revert on failure
            loginItemEnabled = SMAppService.mainApp.status == .enabled
        }
    }
}
