# Changelog

All notable changes to this project will be documented in this file.

## [0.0.4] - 2026-03-05

### Fixed
- Stability and resource management fixes from third code review

## [0.0.3] - 2026-03-05

### Fixed
- Performance, stability, and code quality fixes from second code review

## [0.0.2] - 2026-03-05

### Fixed
- Various concurrency, performance, and security fixes from code review

## [0.0.1] - 2026-03-05

### Added
- Homebrew Cask install: `brew tap juliankang4/tap && brew install claude-status`
- GitHub Releases with pre-built `.app.zip`
- Incident name translation (Korean): "Outage in Usage Reporting" → "사용량 보고 장애"
- Status emoji next to Claude logo in menu bar (✅/⚠️/❌/❓)

### Changed
- Menu bar icon: SVG loaded directly (fixes white square / transparency issue)
- README rewritten in English with Korean section at bottom
- All commit messages in English

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
