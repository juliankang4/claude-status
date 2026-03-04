import SwiftUI
import ServiceManagement

struct SettingsSectionView: View {
    @Bindable var settings: AppSettings
    let monitor: StatusMonitor

    @State private var loginItemEnabled = false
    @State private var showServiceAlerts = false

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

            // Service-specific alert toggles
            if settings.notificationsEnabled && !monitor.components.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showServiceAlerts.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(showServiceAlerts ? "▼" : "▶")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                        Text("🔕")
                        Text(L10n.get(.serviceAlerts, language: settings.language))
                            .font(.system(size: 11))
                    }
                }
                .buttonStyle(.plain)

                if showServiceAlerts {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(monitor.components) { comp in
                            Toggle(isOn: Binding(
                                get: { !settings.mutedServices.contains(comp.id) },
                                set: { enabled in
                                    if enabled {
                                        settings.mutedServices.remove(comp.id)
                                    } else {
                                        settings.mutedServices.insert(comp.id)
                                    }
                                }
                            )) {
                                Text(comp.displayName)
                                    .font(.system(size: 11))
                            }
                            .toggleStyle(.switch)
                            .controlSize(.mini)
                        }
                    }
                    .padding(.leading, 16)
                }
            }

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

            // Refresh interval
            HStack(spacing: 8) {
                Text("⏱")
                Text(L10n.get(.refreshInterval, language: settings.language))
                    .font(.system(size: 11))
                Spacer()
                Picker("", selection: $settings.refreshInterval) {
                    ForEach(AppConstants.refreshIntervalOptions, id: \.self) { interval in
                        Text(L10n.refreshIntervalLabel(interval, language: settings.language))
                            .tag(interval)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
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

            // Update available
            if let release = monitor.latestRelease {
                Button {
                    if let url = URL(string: release.url),
                       url.scheme?.lowercased() == "https" {
                        NSWorkspace.shared.open(url)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("🆕")
                        Text("\(L10n.get(.updateAvailable, language: settings.language)): v\(release.version)")
                            .font(.system(size: 11))
                            .foregroundStyle(.blue)
                    }
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
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
                if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
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
            loginItemEnabled = SMAppService.mainApp.status == .enabled
        }
    }
}
