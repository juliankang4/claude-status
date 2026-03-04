import Foundation

enum L10n {
    static func get(_ key: StringKey, language: AppLanguage) -> String {
        switch language {
        case .korean: key.ko
        case .english: key.en
        }
    }

    enum StringKey {
        case title
        case recentIncidents
        case noIncidents
        case noIncidentData
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
        case launchAtLogin
        case launchAtLoginOn
        case launchAtLoginOff
        case quit

        var en: String {
            switch self {
            case .title: "Claude Service Status"
            case .recentIncidents: "Recent Incidents"
            case .noIncidents: "No incidents"
            case .noIncidentData: "No incident data"
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
            case .launchAtLogin: "Launch at Login"
            case .launchAtLoginOn: "Launch at Login: On"
            case .launchAtLoginOff: "Launch at Login: Off"
            case .quit: "Quit Claude Status"
            }
        }

        var ko: String {
            switch self {
            case .title: "Claude 서비스 상태"
            case .recentIncidents: "최근 장애"
            case .noIncidents: "장애 없음"
            case .noIncidentData: "장애 정보 없음"
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
            case .launchAtLogin: "시작프로그램"
            case .launchAtLoginOn: "시작프로그램: 켜짐"
            case .launchAtLoginOff: "시작프로그램: 꺼짐"
            case .quit: "종료"
            }
        }
    }

    static func statusLabel(_ status: ComponentStatus, language: AppLanguage) -> String {
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

    /// Translate incident name to Korean when language is set to ko
    static func translateIncidentName(_ name: String, language: AppLanguage) -> String {
        guard language == .korean else { return name }

        // Known word translations (applied to the whole string at the end)
        let wordMap: [(String, String)] = [
            ("Usage Reporting", "사용량 보고"),
            ("usage reporting", "사용량 보고"),
            ("login issues", "로그인 문제"),
            ("Login issues", "로그인 문제"),
            ("elevated error rate", "오류율 증가"),
            ("Elevated error rate", "오류율 증가"),
        ]

        // "Prefix <target>" patterns → "<target> 한국어설명"
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

        // No prefix matched — try word-level translation
        return translateWords(name, wordMap: wordMap)
    }

    private static func translateWords(_ text: String, wordMap: [(String, String)]) -> String {
        var result = text
        for (en, ko) in wordMap {
            result = result.replacingOccurrences(of: en, with: ko)
        }
        return result
    }

    static func incidentLabel(_ status: IncidentStatus, language: AppLanguage) -> String {
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
}
