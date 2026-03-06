import WidgetKit
import SwiftUI

@main
struct ClaudeStatusWidgetBundle: WidgetBundle {
    var body: some Widget {
        ClaudeStatusWidget()
    }
}

struct ClaudeStatusWidget: Widget {
    let kind = "ClaudeStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: StatusTimelineProvider()
        ) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Claude Status")
        .description(
            Locale.preferredLanguages.first?.hasPrefix("ko") == true
                ? "Claude 서비스 상태를 확인합니다"
                : "Monitor Claude service status"
        )
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
