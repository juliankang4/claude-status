import Foundation

// MARK: - Summary API Response

struct SummaryResponse: Codable, Sendable {
    let page: PageInfo
    let components: [Component]
    let status: OverallStatus

    enum CodingKeys: String, CodingKey {
        case page, components, status
    }
}

struct PageInfo: Codable, Sendable {
    let id: String
    let name: String
    let url: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, url
        case updatedAt = "updated_at"
    }
}

struct Component: Codable, Sendable, Identifiable {
    let id: String
    let name: String
    let status: ComponentStatus
    let createdAt: String
    let updatedAt: String
    let position: Int
    let showcase: Bool
    let startDate: String?
    let group: Bool
    let onlyShowIfDegraded: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, status, position, showcase, group
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case startDate = "start_date"
        case onlyShowIfDegraded = "only_show_if_degraded"
    }

    var displayName: String {
        // Remove parenthetical suffixes like "(formerly ...)" or "(api....)"
        if let parenRange = name.range(of: " (") {
            return String(name[..<parenRange.lowerBound])
        }
        return name
    }
}

enum ComponentStatus: String, Codable, Sendable {
    case operational
    case degradedPerformance = "degraded_performance"
    case partialOutage = "partial_outage"
    case majorOutage = "major_outage"
    case unknown

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = ComponentStatus(rawValue: value) ?? .unknown
    }
}

struct OverallStatus: Codable, Sendable {
    let indicator: StatusIndicator
    let description: String
}

enum StatusIndicator: String, Codable, Sendable {
    case none
    case minor
    case major
    case critical
    case unknown

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = StatusIndicator(rawValue: value) ?? .unknown
    }
}
