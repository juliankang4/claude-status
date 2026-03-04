import SwiftUI
import AppKit

struct MenuBarIconView: View {
    let indicator: StatusIndicator
    let isOnline: Bool

    var body: some View {
        HStack(spacing: 1) {
            Image(nsImage: menuBarImage)
            Text(statusEmoji)
        }
    }

    private var statusEmoji: String {
        guard isOnline else { return "❓" }
        switch indicator {
        case .none: return "✅"
        case .minor: return "⚠️"
        case .major, .critical: return "❌"
        case .unknown: return "❓"
        }
    }

    private var menuBarImage: NSImage {
        if let url = Bundle.main.url(forResource: "claude-logo", withExtension: "svg"),
           let image = NSImage(contentsOf: url) {
            image.size = NSSize(width: 18, height: 18)
            image.isTemplate = true
            return image
        }

        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size, flipped: false) { rect in
            NSColor.black.setFill()
            NSBezierPath(ovalIn: rect.insetBy(dx: 2, dy: 2)).fill()
            return true
        }
        image.isTemplate = true
        return image
    }
}
