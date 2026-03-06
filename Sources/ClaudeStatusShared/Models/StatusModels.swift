import Foundation

// MARK: - Summary API Response

package struct SummaryResponse: Codable, Sendable {
    package let page: PageInfo
    package let components: [Component]
    package let status: OverallStatus
}

package struct PageInfo: Codable, Sendable {
    package let id: String
    package let name: String
    package let url: String
    package let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, url
        case updatedAt = "updated_at"
    }
}

package struct Component: Codable, Sendable, Identifiable {
    package let id: String
    package let name: String
    package let status: ComponentStatus
    package let createdAt: String
    package let updatedAt: String
    package let position: Int
    package let showcase: Bool
    package let startDate: String?
    package let group: Bool
    package let onlyShowIfDegraded: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, status, position, showcase, group
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case startDate = "start_date"
        case onlyShowIfDegraded = "only_show_if_degraded"
    }

    package var displayName: String {
        if let parenRange = name.range(of: " (") {
            return String(name[..<parenRange.lowerBound])
        }
        return name
    }
}

package enum ComponentStatus: String, Codable, Sendable {
    case operational
    case degradedPerformance = "degraded_performance"
    case partialOutage = "partial_outage"
    case majorOutage = "major_outage"
    case unknown

    package init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = ComponentStatus(rawValue: value) ?? .unknown
    }
}

package struct OverallStatus: Codable, Sendable {
    package let indicator: StatusIndicator
    package let description: String
}

package enum StatusIndicator: String, Codable, Sendable {
    case none
    case minor
    case major
    case critical
    case unknown

    package init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = StatusIndicator(rawValue: value) ?? .unknown
    }
}
