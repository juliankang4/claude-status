import Foundation

enum DateFormatting {
    static func parseISO(_ string: String) -> Date? {
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = fractional.date(from: string) { return date }

        let basic = ISO8601DateFormatter()
        basic.formatOptions = [.withInternetDateTime]
        return basic.date(from: string)
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
        let formatter = DateFormatter()
        if language == .korean {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "a h:mm"
        } else {
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "h:mm a"
        }
        return formatter.string(from: Date())
    }
}
