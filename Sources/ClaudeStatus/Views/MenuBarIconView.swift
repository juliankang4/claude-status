import SwiftUI
import AppKit

struct MenuBarIconView: View {
    let indicator: StatusIndicator
    let isOnline: Bool

    var body: some View {
        HStack(spacing: 2) {
            Image(nsImage: menuBarImage)
            Canvas { context, size in
                let dotSize: CGFloat = 6
                let rect = CGRect(
                    x: size.width - dotSize,
                    y: size.height - dotSize,
                    width: dotSize,
                    height: dotSize
                )
                context.fill(Circle().path(in: rect), with: .color(dotColor))
            }
            .frame(width: 8, height: 16)
        }
    }

    private var menuBarImage: NSImage {
        let bundle = Bundle.main
        let image: NSImage

        if let url = bundle.url(forResource: "menubar_icon", withExtension: "png"),
           let loaded = NSImage(contentsOf: url) {
            image = loaded
        } else {
            // Fallback: create a simple circle
            image = NSImage(size: NSSize(width: 18, height: 18))
        }

        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = true
        return image
    }

    private var dotColor: Color {
        guard isOnline else { return .gray }
        switch indicator {
        case .none: return .green
        case .minor: return .orange
        case .major, .critical: return .red
        case .unknown: return .gray
        }
    }
}
