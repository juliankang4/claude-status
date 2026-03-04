import SwiftUI

@main
struct ClaudeStatusApp: App {
    @State private var monitor = StatusMonitor()
    @State private var settings = AppSettings()
    @State private var notificationService = NotificationService()
    @State private var didSetup = false

    var body: some Scene {
        MenuBarExtra {
            StatusContentView(monitor: monitor, settings: settings)
                .task {
                    guard !didSetup else { return }
                    didSetup = true

                    await notificationService.requestPermission()

                    monitor.onStatusChange = { changes in
                        guard settings.notificationsEnabled else { return }
                        let title = L10n.get(.notificationTitle, language: settings.language)
                        Task {
                            await notificationService.send(title: title, body: changes)
                        }
                    }

                    monitor.start()
                }
        } label: {
            MenuBarIconView(indicator: monitor.currentIndicator, isOnline: monitor.isOnline)
        }
        .menuBarExtraStyle(.window)
    }
}
