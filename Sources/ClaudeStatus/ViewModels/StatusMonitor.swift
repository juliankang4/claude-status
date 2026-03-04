import Foundation
import SwiftUI

@Observable
@MainActor
final class StatusMonitor {
    var summary: SummaryResponse?
    var incidents: IncidentsResponse?
    var isOnline = true
    var lastRefresh: Date?

    private let service = StatusService()
    private var timer: Timer?
    private var activityToken: NSObjectProtocol?
    private var previousStatuses: [String: ComponentStatus] = [:]

    var onStatusChange: ((_ changes: String) -> Void)?

    var currentIndicator: StatusIndicator {
        summary?.status.indicator ?? .unknown
    }

    var menuBarIcon: String {
        guard let summary else { return "☁️❓" }
        return StatusMapping.menuBarIcon(for: summary.status.indicator, online: isOnline)
    }

    var components: [Component] {
        summary?.components.filter { $0.showcase && !$0.group } ?? []
    }

    var recentIncidents: [Incident] {
        Array((incidents?.incidents ?? []).prefix(5))
    }

    func start() {
        // Prevent App Nap
        activityToken = ProcessInfo.processInfo.beginActivity(
            options: [.userInitiated, .idleSystemSleepDisabled],
            reason: "Status monitoring requires periodic updates"
        )

        // Initial fetch
        Task { await refresh() }

        // 15-second timer
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                await self.refresh()
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

        // Change detection
        if isOnline, let components = summary?.components {
            detectChanges(components)
        }
    }

    // MARK: - 30-day uptime data

    /// Returns an array of DayStatus for the last 30 days for a given component
    func uptimeData(for component: Component) -> [DayStatus] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let allIncidents = incidents?.incidents ?? []
        let startDate = component.startDate.flatMap { dateFromString($0) }

        return (0..<30).reversed().map { daysAgo in
            let day = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let dayStr = dayString(day)

            // Before component start date
            if let start = startDate, day < start {
                return DayStatus(date: day, status: .noData)
            }

            // Check incidents affecting this component on this day
            let impacts = allIncidents.compactMap { incident -> IncidentImpact? in
                let incStart = incident.startedAt.prefix(10)
                let incEnd = (incident.resolvedAt ?? "9999-12-31").prefix(10)

                guard dayStr >= incStart && dayStr <= incEnd else { return nil }

                // Check if this component was affected
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
    }

    // MARK: - Private

    private func detectChanges(_ components: [Component]) {
        var changes: [String] = []

        for comp in components {
            if let prev = previousStatuses[comp.id], prev != comp.status {
                let name = comp.displayName
                let label = L10n.statusLabel(comp.status, language: .english)
                changes.append("\(name) → \(label)")
            }
            previousStatuses[comp.id] = comp.status
        }

        if !changes.isEmpty {
            onStatusChange?(changes.joined(separator: ", "))
        }
    }

    private func dateFromString(_ s: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.date(from: s)
    }

    private func dayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
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
