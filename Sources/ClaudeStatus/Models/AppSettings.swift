import Foundation
import SwiftUI

@Observable
@MainActor
final class AppSettings {
    var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }

    var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: "language") }
    }

    init() {
        let defaults = UserDefaults.standard
        let systemLang = Locale.preferredLanguages.first?.hasPrefix("ko") == true ? "ko" : "en"
        defaults.register(defaults: [
            "notificationsEnabled": true,
            "language": systemLang
        ])

        self.notificationsEnabled = defaults.bool(forKey: "notificationsEnabled")
        self.language = AppLanguage(rawValue: defaults.string(forKey: "language") ?? "en") ?? .english
    }
}

enum AppLanguage: String, Sendable {
    case english = "en"
    case korean = "ko"
}
