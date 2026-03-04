import SwiftUI

@main
struct ClaudeStatusApp: App {
    @State private var monitor = StatusMonitor()
    @State private var settings = AppSettings()
    private let notificationService = NotificationService()
    @State private var didSetup = false

    var body: some Scene {
        MenuBarExtra {
            StatusContentView(monitor: monitor, settings: settings)
                .task {
                    guard !didSetup else { return }
                    didSetup = true

                    await notificationService.requestPermission()

                    monitor.language = settings.language
                    monitor.onStatusChange = { @MainActor changes in
                        guard settings.notificationsEnabled else { return }
                        let title = L10n.get(.notificationTitle, language: settings.language)
                        Task {
                            await notificationService.send(title: title, body: changes)
                        }
                    }

                    monitor.start()
                }
                .onChange(of: settings.language) { _, newLang in
                    monitor.language = newLang
                }
        } label: {
            MenuBarIconView(indicator: monitor.currentIndicator, isOnline: monitor.isOnline)
        }
        .menuBarExtraStyle(.window)
    }
}
