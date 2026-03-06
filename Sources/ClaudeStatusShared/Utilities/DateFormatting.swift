import Foundation

package enum DateFormatting {
    nonisolated(unsafe) private static let fractionalFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    nonisolated(unsafe) private static let basicFormatter: ISO8601DateFormatter = {
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

    package static func parseISO(_ string: String) -> Date? {
        if let date = fractionalFormatter.date(from: string) { return date }
        return basicFormatter.date(from: string)
    }

    package static func shortDate(_ string: String) -> String {
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

    package static func time(_ date: Date, language: AppLanguage) -> String {
        let formatter = language == .korean ? timeFormatterKO : timeFormatterEN
        return formatter.string(from: date)
    }

    // MARK: - Duration

    package static func duration(from startString: String, to endDate: Date?, language: AppLanguage) -> String? {
        guard let start = parseISO(startString) else { return nil }
        let end = endDate ?? Date()
        let interval = end.timeIntervalSince(start)
        guard interval > 0 else { return nil }

        let totalMinutes = Int(interval) / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        let isOngoing = (endDate == nil)

        switch language {
        case .korean:
            if hours > 0 && minutes > 0 {
                return isOngoing ? "\(hours)시간 \(minutes)분째" : "\(hours)시간 \(minutes)분"
            } else if hours > 0 {
                return isOngoing ? "\(hours)시간째" : "\(hours)시간"
            } else {
                return isOngoing ? "\(max(1, minutes))분째" : "\(max(1, minutes))분"
            }
        case .english:
            if hours > 0 && minutes > 0 {
                return isOngoing ? "\(hours)h \(minutes)m ongoing" : "\(hours)h \(minutes)m"
            } else if hours > 0 {
                return isOngoing ? "\(hours)h ongoing" : "\(hours)h"
            } else {
                return isOngoing ? "\(max(1, minutes))m ongoing" : "\(max(1, minutes))m"
            }
        }
    }
}
