import Foundation
import SwiftUI
import Network

@Observable
@MainActor
final class StatusMonitor {
    var summary: SummaryResponse?
    var incidents: IncidentsResponse?
    var isOnline = true
    var lastRefresh: Date?
    var language: AppLanguage = .english
    var latestRelease: StatusService.LatestRelease?
    var isNetworkAvailable = true

    private let service = StatusService()
    private var refreshTask: Task<Void, Never>?
    private var activityToken: NSObjectProtocol?
    private var previousStatuses: [String: ComponentStatus] = [:]
    private var uptimeCache: [String: [DayStatus]] = [:]
    private var lastComponentIDs: [String] = []
    private var lastIncidentIDs: [String] = []

    private var pathMonitor: NWPathMonitor?
    private var pathMonitorQueue = DispatchQueue(label: "com.julianyoon.claude-status.network")

    var onStatusChange: (@MainActor (_ changes: String) -> Void)?

    // Settings references (set by ClaudeStatusApp)
    var refreshInterval: TimeInterval = AppConstants.defaultRefreshInterval
    var mutedServices: Set<String> = []

    var currentIndicator: StatusIndicator {
        summary?.status.indicator ?? .unknown
    }

    var components: [Component] {
        summary?.components.filter { $0.showcase && !$0.group } ?? []
    }

    var recentIncidents: [Incident] {
        Array((incidents?.incidents ?? []).prefix(AppConstants.maxRecentIncidents))
    }

    func start() {
        // Prevent App Nap
        activityToken = ProcessInfo.processInfo.beginActivity(
            options: .userInitiatedAllowingIdleSystemSleep,
            reason: "Status monitoring requires periodic updates"
        )

        // Network monitor
        startNetworkMonitor()

        // Check for updates (once)
        Task {
            latestRelease = await service.checkForUpdate()
        }

        // Start refresh loop
        startRefreshLoop()
    }

    func stop() {
        refreshTask?.cancel()
        refreshTask = nil
        pathMonitor?.cancel()
        pathMonitor = nil
        if let token = activityToken {
            ProcessInfo.processInfo.endActivity(token)
            activityToken = nil
        }
    }

    func restartRefreshLoop() {
        refreshTask?.cancel()
        startRefreshLoop()
    }

    func refresh() async {
        guard isNetworkAvailable else { return }

        let result = await service.fetch()

        summary = result.summary
        incidents = result.incidents
        isOnline = result.isOnline
        lastRefresh = Date()

        // Rebuild uptime cache off main thread
        await rebuildUptimeCache()

        if isOnline, let components = summary?.components {
            detectChanges(components)
        }
    }

    // MARK: - 30-day uptime data

    func uptimeData(for component: Component) -> [DayStatus] {
        uptimeCache[component.id] ?? []
    }

    // MARK: - Private

    private func startNetworkMonitor() {
        pathMonitor = NWPathMonitor()
        pathMonitor?.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self else { return }
                let wasAvailable = self.isNetworkAvailable
                self.isNetworkAvailable = (path.status == .satisfied)

                // Network restored → immediate refresh
                if !wasAvailable && self.isNetworkAvailable {
                    await self.refresh()
                }
            }
        }
        pathMonitor?.start(queue: pathMonitorQueue)
    }

    private func startRefreshLoop() {
        refreshTask = Task { [weak self] in
            guard let self else { return }
            await self.refresh()

            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(self.refreshInterval))
                guard !Task.isCancelled else { break }
                await self.refresh()
            }
        }
    }

    private func rebuildUptimeCache() async {
        guard let comps = summary?.components else { return }

        // Skip rebuild if data hasn't changed
        let componentIDs = comps.map { "\($0.id):\($0.status.rawValue)" }
        let incidentIDs = (incidents?.incidents ?? []).map { "\($0.id):\($0.updatedAt)" }
        if componentIDs == lastComponentIDs && incidentIDs == lastIncidentIDs {
            return
        }
        lastComponentIDs = componentIDs
        lastIncidentIDs = incidentIDs

        let allIncidents = incidents?.incidents ?? []
        let cache = await service.buildUptimeCache(components: comps, incidents: allIncidents)
        uptimeCache = cache
    }

    private func detectChanges(_ components: [Component]) {
        var changes: [String] = []

        for comp in components {
            if let prev = previousStatuses[comp.id], prev != comp.status {
                // Skip muted services
                guard !mutedServices.contains(comp.id) else { continue }

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
