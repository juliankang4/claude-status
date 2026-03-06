import Foundation

// MARK: - Incidents API Response

package struct IncidentsResponse: Codable, Sendable {
    package let page: PageInfo
    package let incidents: [Incident]
}

package struct Incident: Codable, Sendable, Identifiable {
    package let id: String
    package let name: String
    package let status: IncidentStatus
    package let createdAt: String
    package let updatedAt: String
    package let monitoringAt: String?
    package let resolvedAt: String?
    package let impact: IncidentImpact
    package let shortlink: String
    package let startedAt: String
    package let incidentUpdates: [IncidentUpdate]

    enum CodingKeys: String, CodingKey {
        case id, name, status, impact, shortlink
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case monitoringAt = "monitoring_at"
        case resolvedAt = "resolved_at"
        case startedAt = "started_at"
        case incidentUpdates = "incident_updates"
    }
}

package struct IncidentUpdate: Codable, Sendable {
    package let id: String
    package let status: IncidentStatus
    package let body: String
    package let createdAt: String
    package let affectedComponents: [AffectedComponent]?

    enum CodingKeys: String, CodingKey {
        case id, status, body
        case createdAt = "created_at"
        case affectedComponents = "affected_components"
    }
}

package struct AffectedComponent: Codable, Sendable {
    package let code: String
    package let name: String
    package let oldStatus: String
    package let newStatus: String

    enum CodingKeys: String, CodingKey {
        case code, name
        case oldStatus = "old_status"
        case newStatus = "new_status"
    }
}

package enum IncidentStatus: String, Codable, Sendable {
    case investigating
    case identified
    case monitoring
    case resolved
    case postmortem
    case unknown

    package init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = IncidentStatus(rawValue: value) ?? .unknown
    }
}

package enum IncidentImpact: String, Codable, Sendable {
    case none
    case minor
    case major
    case critical
    case unknown

    package init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = IncidentImpact(rawValue: value) ?? .unknown
    }
}
