import Foundation
import UserNotifications

actor NotificationService {
    private var authorized = false

    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            authorized = try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            authorized = false
        }
    }

    func send(title: String, body: String) async {
        if !authorized {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            guard settings.authorizationStatus == .authorized else { return }
            authorized = true
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("Glass"))

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        try? await UNUserNotificationCenter.current().add(request)
    }
}
