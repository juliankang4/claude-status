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
