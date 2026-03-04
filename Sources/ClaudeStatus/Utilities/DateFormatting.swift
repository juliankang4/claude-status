import Foundation

@MainActor
enum DateFormatting {
    private static let fractionalFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let basicFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static let timeFormatterEN: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "h:mm a"
        return f
    }()

    private static let timeFormatterKO: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "a h:mm"
        return f
    }()

    static func parseISO(_ string: String) -> Date? {
        if let date = fractionalFormatter.date(from: string) { return date }
        return basicFormatter.date(from: string)
    }

    static func shortDate(_ string: String) -> String {
        guard let date = parseISO(string) else {
            let parts = string.prefix(10).split(separator: "-")
            guard parts.count >= 3 else { return string }
            let month = Int(parts[1]) ?? 0
            let day = Int(parts[2]) ?? 0
            return "\(month)/\(day)"
        }
        let cal = Calendar.current
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        return "\(month)/\(day)"
    }

    static func currentTime(language: AppLanguage) -> String {
        let formatter = language == .korean ? timeFormatterKO : timeFormatterEN
        return formatter.string(from: Date())
    }
}
