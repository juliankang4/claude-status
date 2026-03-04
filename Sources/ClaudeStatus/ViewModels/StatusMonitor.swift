import Foundation
import SwiftUI

@Observable
@MainActor
final class StatusMonitor {
    var summary: SummaryResponse?
    var incidents: IncidentsResponse?
    var isOnline = true
    var lastRefresh: Date?
    var language: AppLanguage = .english

    private let service = StatusService()
    private var timer: Timer?
    private var activityToken: NSObjectProtocol?
    private var previousStatuses: [String: ComponentStatus] = [:]
    private var uptimeCache: [String: [DayStatus]] = [:]
    private var lastComponentIDs: [String] = []
    private var lastIncidentIDs: [String] = []

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()

    var onStatusChange: (@MainActor (_ changes: String) -> Void)?

    var currentIndicator: StatusIndicator {
        summary?.status.indicator ?? .unknown
    }

    var components: [Component] {
        summary?.components.filter { $0.showcase && !$0.group } ?? []
    }

    var recentIncidents: [Incident] {
        Array((incidents?.incidents ?? []).prefix(5))
    }

    func start() {
        // Prevent App Nap (not system sleep)
        activityToken = ProcessInfo.processInfo.beginActivity(
            options: .userInitiatedAllowingIdleSystemSleep,
            reason: "Status monitoring requires periodic updates"
        )

        Task { await refresh() }

        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            Task { @MainActor [weak self] in
                await self?.refresh()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        if let token = activityToken {
            ProcessInfo.processInfo.endActivity(token)
            activityToken = nil
        }
    }

    func refresh() async {
        let result = await service.fetch()

        summary = result.summary
        incidents = result.incidents
        isOnline = result.isOnline
        lastRefresh = Date()

        // Rebuild uptime cache
        rebuildUptimeCache()

        if isOnline, let components = summary?.components {
            detectChanges(components)
        }
    }

    // MARK: - 30-day uptime data (cached)

    func uptimeData(for component: Component) -> [DayStatus] {
        uptimeCache[component.id] ?? []
    }

    private func rebuildUptimeCache() {
        guard let comps = summary?.components else { return }

        // Skip rebuild if data hasn't changed
        let componentIDs = comps.map { "\($0.id):\($0.status.rawValue)" }
        let incidentIDs = (incidents?.incidents ?? []).map { "\($0.id):\($0.updatedAt)" }
        if componentIDs == lastComponentIDs && incidentIDs == lastIncidentIDs {
            return
        }
        lastComponentIDs = componentIDs
        lastIncidentIDs = incidentIDs

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let allIncidents = incidents?.incidents ?? []

        for component in comps {
            let startDate = component.startDate.flatMap { dateFormatter.date(from: $0) }

            let data: [DayStatus] = (0..<30).reversed().map { daysAgo in
                let day = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
                let dayStr = dateFormatter.string(from: day)

                if let start = startDate, day < start {
                    return DayStatus(date: day, status: .noData)
                }

                let impacts = allIncidents.compactMap { incident -> IncidentImpact? in
                    let incStart = incident.startedAt.prefix(10)
                    let incEnd = (incident.resolvedAt ?? "9999-12-31").prefix(10)
                    guard dayStr >= incStart && dayStr <= incEnd else { return nil }

                    let affected = incident.incidentUpdates.contains { update in
                        update.affectedComponents?.contains { $0.code == component.id } ?? false
                    }
                    return affected ? incident.impact : nil
                }

                if impacts.isEmpty {
                    return DayStatus(date: day, status: .operational)
                } else if impacts.contains(where: { $0 == .major || $0 == .critical }) {
                    return DayStatus(date: day, status: .major)
                } else {
                    return DayStatus(date: day, status: .minor)
                }
            }
            uptimeCache[component.id] = data
        }
    }

    // MARK: - Private

    private func detectChanges(_ components: [Component]) {
        var changes: [String] = []

        for comp in components {
            if let prev = previousStatuses[comp.id], prev != comp.status {
                let name = comp.displayName
                let label = L10n.statusLabel(comp.status, language: language)
                changes.append("\(name) → \(label)")
            }
            previousStatuses[comp.id] = comp.status
        }

        if !changes.isEmpty {
            onStatusChange?(changes.joined(separator: ", "))
        }
    }
}

enum UptimeStatus: Sendable {
    case operational
    case minor
    case major
    case noData
}

struct DayStatus: Sendable {
    let date: Date
    let status: UptimeStatus
}
