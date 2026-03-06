import WidgetKit
import ClaudeStatusShared

struct StatusEntry: TimelineEntry {
    let date: Date
    let indicator: StatusIndicator
    let components: [Component]
    let recentIncidents: [Incident]
    let isError: Bool
    let language: AppLanguage
}

private struct SendableCallback<T>: @unchecked Sendable {
    let call: (T) -> Void
}

struct StatusTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> StatusEntry {
        StatusEntry(
            date: .now,
            indicator: .none,
            components: [],
            recentIncidents: [],
            isError: false,
            language: systemLanguage
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (StatusEntry) -> Void) {
        if context.isPreview {
            completion(placeholder(in: context))
            return
        }

        let callback = SendableCallback(call: completion)
        Task {
            let entry = await fetchEntry()
            callback.call(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StatusEntry>) -> Void) {
        let callback = SendableCallback(call: completion)
        Task {
            let entry = await fetchEntry()
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: entry.date)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            callback.call(timeline)
        }
    }

    private func fetchEntry() async -> StatusEntry {
        let result = await WidgetStatusService.fetch()
        let lang = systemLanguage

        if let summary = result.summary {
            let showcaseComponents = summary.components.filter { $0.showcase && !$0.group }
            let incidents = Array(
                (result.incidents?.incidents ?? []).prefix(SharedConstants.maxRecentIncidents)
            )

            return StatusEntry(
                date: .now,
                indicator: summary.status.indicator,
                components: showcaseComponents,
                recentIncidents: incidents,
                isError: false,
                language: lang
            )
        }

        return StatusEntry(
            date: .now,
            indicator: .unknown,
            components: [],
            recentIncidents: [],
            isError: true,
            language: lang
        )
    }

    private var systemLanguage: AppLanguage {
        Locale.preferredLanguages.first?.hasPrefix("ko") == true ? .korean : .english
    }
}
