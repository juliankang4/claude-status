import Foundation

// MARK: - Incidents API Response

struct IncidentsResponse: Codable, Sendable {
    let page: PageInfo
    let incidents: [Incident]
}

struct Incident: Codable, Sendable, Identifiable {
    let id: String
    let name: String
    let status: IncidentStatus
    let createdAt: String
    let updatedAt: String
    let monitoringAt: String?
    let resolvedAt: String?
    let impact: IncidentImpact
    let shortlink: String
    let startedAt: String
    let incidentUpdates: [IncidentUpdate]

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

struct IncidentUpdate: Codable, Sendable {
    let id: String
    let status: IncidentStatus
    let body: String
    let createdAt: String
    let affectedComponents: [AffectedComponent]?

    enum CodingKeys: String, CodingKey {
        case id, status, body
        case createdAt = "created_at"
        case affectedComponents = "affected_components"
    }
}

struct AffectedComponent: Codable, Sendable {
    let code: String
    let name: String
    let oldStatus: String
    let newStatus: String

    enum CodingKeys: String, CodingKey {
        case code, name
        case oldStatus = "old_status"
        case newStatus = "new_status"
    }
}

enum IncidentStatus: String, Codable, Sendable {
    case investigating
    case identified
    case monitoring
    case resolved
    case postmortem
    case unknown

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = IncidentStatus(rawValue: value) ?? .unknown
    }
}

enum IncidentImpact: String, Codable, Sendable {
    case none
    case minor
    case major
    case critical
    case unknown

    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = IncidentImpact(rawValue: value) ?? .unknown
    }
}
