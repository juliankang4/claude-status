// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ClaudeStatus",
    platforms: [.macOS(.v14)],
    targets: [
        .target(
            name: "ClaudeStatusShared",
            path: "Sources/ClaudeStatusShared"
        ),
        .executableTarget(
            name: "ClaudeStatus",
            dependencies: ["ClaudeStatusShared"],
            path: "Sources/ClaudeStatus"
        ),
        .target(
            name: "ClaudeStatusWidget",
            dependencies: ["ClaudeStatusShared"],
            path: "Sources/ClaudeStatusWidget"
        )
    ]
)
