import SwiftUI
import ClaudeStatusShared

struct UptimeBarView: View {
    let data: [DayStatus]
    let label: String
    let language: AppLanguage

    var body: some View {
        HStack(spacing: 1) {
            ForEach(Array(data.enumerated()), id: \.offset) { _, day in
                RoundedRectangle(cornerRadius: 1)
                    .fill(color(for: day.status))
                    .frame(height: 8)
                    .help(tooltip(for: day))
            }

            Text(label)
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
        .frame(height: 10)
    }

    private func color(for status: UptimeStatus) -> Color {
        switch status {
        case .operational: Color(red: 0.46, green: 0.68, blue: 0.16) // #76AD2A
        case .minor: Color(red: 0.98, green: 0.65, blue: 0.16) // #FAA72A
        case .major: Color(red: 0.88, green: 0.26, blue: 0.26) // #E04343
        case .noData: Color(red: 0.78, green: 0.78, blue: 0.78) // #C8C8C8
        }
    }

    private func tooltip(for day: DayStatus) -> String {
        let cal = Calendar.current
        let month = cal.component(.month, from: day.date)
        let dayNum = cal.component(.day, from: day.date)
        let dateStr = "\(month)/\(dayNum)"

        let statusStr: String
        switch language {
        case .korean:
            switch day.status {
            case .operational: statusStr = "정상"
            case .minor: statusStr = "장애"
            case .major: statusStr = "심각한 장애"
            case .noData: statusStr = "데이터 없음"
            }
        case .english:
            switch day.status {
            case .operational: statusStr = "Operational"
            case .minor: statusStr = "Incident"
            case .major: statusStr = "Major Incident"
            case .noData: statusStr = "No Data"
            }
        }

        return "\(dateStr) — \(statusStr)"
    }
}
