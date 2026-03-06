import SwiftUI
import Carbon.HIToolbox
import ClaudeStatusShared

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

                    monitor.language = settings.language
                    monitor.refreshInterval = settings.refreshInterval
                    monitor.mutedServices = settings.mutedServices
                    monitor.onStatusChange = { @MainActor changes in
                        guard settings.notificationsEnabled else { return }
                        let title = L10n.get(.notificationTitle, language: settings.language)
                        Task {
                            await notificationService.send(title: title, body: changes)
                        }
                    }

                    monitor.start()
                    registerGlobalHotkey()
                    registerTerminationObserver()
                }
                .onChange(of: settings.language) { _, newLang in
                    monitor.language = newLang
                }
                .onChange(of: settings.refreshInterval) { _, newInterval in
                    monitor.refreshInterval = newInterval
                    monitor.restartRefreshLoop()
                }
                .onChange(of: settings.mutedServices) { _, newMuted in
                    monitor.mutedServices = newMuted
                }
        } label: {
            MenuBarIconView(indicator: monitor.currentIndicator, isOnline: monitor.isOnline)
        }
        .menuBarExtraStyle(.window)
    }

    // MARK: - Termination

    private func registerTerminationObserver() {
        NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [monitor] _ in
            Task { @MainActor in
                monitor.stop()
            }
        }
    }

    // MARK: - Global Hotkey (Cmd+Shift+C)

    private func registerGlobalHotkey() {
        let handler: (NSEvent) -> Void = { event in
            let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            if event.keyCode == AppConstants.hotkeyKeyCode
                && flags == [.command, .shift] {
                Task { @MainActor in
                    togglePopover()
                }
            }
        }

        NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: handler)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            handler(event)
            return event
        }
    }

    @MainActor
    private func togglePopover() {
        guard let button = NSApp.windows
            .compactMap({ $0.value(forKey: "_statusItem") as? NSStatusItem })
            .first?.button else { return }
        button.performClick(nil)
    }
}
