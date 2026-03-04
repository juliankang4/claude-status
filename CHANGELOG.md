# Changelog

All notable changes to this project will be documented in this file.

## [0.0.0] - 2026-03-05

### Added
- Native macOS menu bar app built with Swift 6 / SwiftUI
- Real-time monitoring of Claude services (15-second auto-refresh)
- Menu bar icon: Claude logo with colored status dot (green/orange/red/gray)
- App icon derived from Claude logo SVG
- Service status display for claude.ai, platform, API, Claude Code, Government
- 30-day uptime bar for each service
- Recent incidents list (latest 5), click to open in browser
- Offline cache — shows cached data when internet is unavailable
- macOS notifications on status changes (toggle on/off)
- Bilingual support (English / Korean)
- Launch at Login toggle (SMAppService)
- Hidden from Dock and Cmd+Tab (LSUIElement)
- App Nap prevention for reliable timer updates
- Build scripts (`build.sh`, `run.sh`) — no Xcode required
