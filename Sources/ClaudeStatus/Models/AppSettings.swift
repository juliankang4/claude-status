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

    var mutedServices: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(mutedServices), forKey: "mutedServices")
        }
    }

    var refreshInterval: TimeInterval {
        didSet {
            UserDefaults.standard.set(refreshInterval, forKey: "refreshInterval")
        }
    }

    init() {
        let defaults = UserDefaults.standard
        let systemLang = Locale.preferredLanguages.first?.hasPrefix("ko") == true ? "ko" : "en"
        defaults.register(defaults: [
            "notificationsEnabled": true,
            "language": systemLang,
            "refreshInterval": AppConstants.defaultRefreshInterval
        ])

        self.notificationsEnabled = defaults.bool(forKey: "notificationsEnabled")
        self.language = AppLanguage(rawValue: defaults.string(forKey: "language") ?? "en") ?? .english

        let savedInterval = defaults.double(forKey: "refreshInterval")
        self.refreshInterval = savedInterval > 0 ? savedInterval : AppConstants.defaultRefreshInterval

        if let saved = defaults.array(forKey: "mutedServices") as? [String] {
            self.mutedServices = Set(saved)
        } else {
            self.mutedServices = []
        }
    }
}

enum AppLanguage: String, Sendable {
    case english = "en"
    case korean = "ko"
}
