import Foundation
import SwiftUI

@Observable
@MainActor
final class AppSettings {
    private enum Key {
        static let notificationsEnabled = "notificationsEnabled"
        static let language = "language"
        static let mutedServices = "mutedServices"
        static let refreshInterval = "refreshInterval"
    }

    var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: Key.notificationsEnabled) }
    }

    var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: Key.language) }
    }

    var mutedServices: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(mutedServices), forKey: Key.mutedServices)
        }
    }

    var refreshInterval: TimeInterval {
        didSet {
            UserDefaults.standard.set(refreshInterval, forKey: Key.refreshInterval)
        }
    }

    init() {
        let defaults = UserDefaults.standard
        let systemLang = Locale.preferredLanguages.first?.hasPrefix("ko") == true ? "ko" : "en"
        defaults.register(defaults: [
            Key.notificationsEnabled: true,
            Key.language: systemLang,
            Key.refreshInterval: AppConstants.defaultRefreshInterval
        ])

        self.notificationsEnabled = defaults.bool(forKey: Key.notificationsEnabled)
        self.language = AppLanguage(rawValue: defaults.string(forKey: Key.language) ?? "en") ?? .english

        let savedInterval = defaults.double(forKey: Key.refreshInterval)
        self.refreshInterval = savedInterval > 0 ? savedInterval : AppConstants.defaultRefreshInterval

        if let saved = defaults.array(forKey: Key.mutedServices) as? [String] {
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
