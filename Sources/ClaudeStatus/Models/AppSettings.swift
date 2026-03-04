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

        if defaults.object(forKey: "notificationsEnabled") == nil {
            defaults.set(true, forKey: "notificationsEnabled")
        }
        if defaults.string(forKey: "language") == nil {
            // Default to system language
            let preferred = Locale.preferredLanguages.first ?? "en"
            let lang = preferred.hasPrefix("ko") ? "ko" : "en"
            defaults.set(lang, forKey: "language")
        }

        self.notificationsEnabled = defaults.bool(forKey: "notificationsEnabled")
        self.language = AppLanguage(rawValue: defaults.string(forKey: "language") ?? "en") ?? .english
    }
}

enum AppLanguage: String, Sendable {
    case english = "en"
    case korean = "ko"
}
