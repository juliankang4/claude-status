import Foundation

package enum L10n {
    package static func get(_ key: StringKey, language: AppLanguage) -> String {
        switch language {
        case .korean: key.ko
        case .english: key.en
        }
    }

    package enum StringKey {
        case title
        case recentIncidents
        case noIncidents
        case noData
        case lastChecked
        case offline
        case openStatusPage
        case refresh
        case settings
        case notificationsOn
        case notificationsOff
        case language
        case notificationTitle
        case thirtyDays
        case launchAtLoginOn
        case launchAtLoginOff
        case quit
        // v0.0.5
        case duration
        case openInBrowser
        case refreshInterval
        case serviceAlerts
        case updateAvailable
        var en: String {
            switch self {
            case .title: "Claude Service Status"
            case .recentIncidents: "Recent Incidents"
            case .noIncidents: "No incidents"
            case .noData: "Unable to fetch data"
            case .lastChecked: "Last checked"
            case .offline: "Offline (showing cache)"
            case .openStatusPage: "Open Status Page"
            case .refresh: "Refresh"
            case .settings: "Settings"
            case .notificationsOn: "Notifications: On"
            case .notificationsOff: "Notifications: Off"
            case .language: "Language"
            case .notificationTitle: "Claude Status Changed"
            case .thirtyDays: "30d"
            case .launchAtLoginOn: "Launch at Login: On"
            case .launchAtLoginOff: "Launch at Login: Off"
            case .quit: "Quit Claude Status"
            // v0.0.5
            case .duration: "Duration"
            case .openInBrowser: "Open in browser"
            case .refreshInterval: "Refresh interval"
            case .serviceAlerts: "Service alerts"
            case .updateAvailable: "Update available"
            }
        }

        var ko: String {
            switch self {
            case .title: "Claude 서비스 상태"
            case .recentIncidents: "최근 장애"
            case .noIncidents: "장애 없음"
            case .noData: "데이터를 가져올 수 없습니다"
            case .lastChecked: "마지막 확인"
            case .offline: "연결 실패 (캐시 표시중)"
            case .openStatusPage: "상태 페이지 열기"
            case .refresh: "새로고침"
            case .settings: "설정"
            case .notificationsOn: "알림: 켜짐"
            case .notificationsOff: "알림: 꺼짐"
            case .language: "언어"
            case .notificationTitle: "Claude 상태 변경"
            case .thirtyDays: "30일"
            case .launchAtLoginOn: "시작프로그램: 켜짐"
            case .launchAtLoginOff: "시작프로그램: 꺼짐"
            case .quit: "종료"
            // v0.0.5
            case .duration: "지속 시간"
            case .openInBrowser: "브라우저에서 열기"
            case .refreshInterval: "갱신 주기"
            case .serviceAlerts: "서비스별 알림"
            case .updateAvailable: "업데이트 가능"
            }
        }
    }

    package static func statusLabel(_ status: ComponentStatus, language: AppLanguage) -> String {
        switch language {
        case .korean:
            switch status {
            case .operational: "정상"
            case .degradedPerformance: "성능 저하"
            case .partialOutage: "부분 장애"
            case .majorOutage: "심각한 장애"
            case .unknown: "알 수 없음"
            }
        case .english:
            switch status {
            case .operational: "Operational"
            case .degradedPerformance: "Degraded"
            case .partialOutage: "Partial Outage"
            case .majorOutage: "Major Outage"
            case .unknown: "Unknown"
            }
        }
    }

    package static func translateIncidentName(_ name: String, language: AppLanguage) -> String {
        guard language == .korean else { return name }

        let wordMap: [(String, String)] = [
            ("Usage Reporting", "사용량 보고"),
            ("usage reporting", "사용량 보고"),
            ("login issues", "로그인 문제"),
            ("Login issues", "로그인 문제"),
            ("elevated error rate", "오류율 증가"),
            ("Elevated error rate", "오류율 증가"),
        ]

        let prefixPatterns: [(String, String)] = [
            ("Elevated errors on ", " 오류 증가"),
            ("Elevated errors in ", " 오류 증가"),
            ("Elevated error rates on ", " 오류율 증가"),
            ("Elevated error rates in ", " 오류율 증가"),
            ("Outage in ", " 장애"),
            ("Outage on ", " 장애"),
            ("Degraded performance on ", " 성능 저하"),
            ("Degraded performance in ", " 성능 저하"),
            ("Increased latency on ", " 지연 증가"),
            ("Increased latency in ", " 지연 증가"),
            ("Service disruption on ", " 서비스 중단"),
            ("Service disruption in ", " 서비스 중단"),
            ("Intermittent errors on ", " 간헐적 오류"),
            ("Intermittent errors in ", " 간헐적 오류"),
        ]

        for (prefix, suffix) in prefixPatterns {
            if let range = name.range(of: prefix, options: .caseInsensitive) {
                let target = translateWords(String(name[range.upperBound...]), wordMap: wordMap)
                return target + suffix
            }
        }

        return translateWords(name, wordMap: wordMap)
    }

    private static func translateWords(_ text: String, wordMap: [(String, String)]) -> String {
        var result = text
        for (en, ko) in wordMap {
            result = result.replacingOccurrences(of: en, with: ko)
        }
        return result
    }

    package static func incidentLabel(_ status: IncidentStatus, language: AppLanguage) -> String {
        switch language {
        case .korean:
            switch status {
            case .resolved, .postmortem: "해결됨"
            case .monitoring: "모니터링"
            case .identified: "확인됨"
            case .investigating: "조사중"
            case .unknown: "알 수 없음"
            }
        case .english:
            switch status {
            case .resolved, .postmortem: "Resolved"
            case .monitoring: "Monitoring"
            case .identified: "Identified"
            case .investigating: "Investigating"
            case .unknown: "Unknown"
            }
        }
    }

    package static func refreshIntervalLabel(_ interval: TimeInterval, language: AppLanguage) -> String {
        let seconds = Int(interval)
        switch language {
        case .korean:
            if seconds < 60 { return "\(seconds)초" }
            return "\(seconds / 60)분"
        case .english:
            if seconds < 60 { return "\(seconds)s" }
            return "\(seconds / 60)m"
        }
    }
}
