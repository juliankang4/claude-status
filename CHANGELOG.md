# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2026-03-06

### Changed
- Widget UI redesign: larger fonts (11-16pt), status banner with color tint, icon glow effect, Claude brand color accent, colored incident status labels, improved spacing and information density

## [0.1.0] - 2026-03-06

### Added
- Desktop widget (macOS 14+ WidgetKit): small, medium, large sizes with 15-minute auto-refresh
  - Small: overall status icon + label
  - Medium: overall status + service list (up to 5)
  - Large: service list with status labels + recent incidents (up to 3)
- Widget taps open status.claude.com in browser
- Bilingual widget: auto-detects system language (Korean/English)
- xcodegen (project.yml) for reproducible Xcode project generation
- ClaudeStatusShared framework: shared models, utilities, and localization across app and widget

### Changed
- Project restructured into 3 targets: ClaudeStatusShared (framework), ClaudeStatus (app), ClaudeStatusWidgetExtension (widget)
- build.sh now uses xcodebuild when Xcode + xcodegen available; falls back to swift build for menu bar only
- Version bumped to 0.1.0 (minor version for widget feature)

## [0.0.11] - 2026-03-06

### Fixed
- Bug fixes and stability improvements: offline refresh now loads cached snapshots, overlapping refresh requests are coalesced, short-link redirects are validated before opening, uptime cache building avoids repeated full incident scans, and incident HTML text parsing moved into a shared utility.

## [0.0.10] - 2026-03-05

### Fixed
- Cache directory permission setup failures now logged instead of silently ignored

## [0.0.9] - 2026-03-05

### Fixed
- Bug fix: offline state now immediately reflected in UI, cache directory permissions enforced on existing installs

## [0.0.8] - 2026-03-05

### Fixed
- Security hardening: URL domain allowlist, cache directory permissions (0700), HTML stripping improvement

## [0.0.7] - 2026-03-05

### Fixed
- Bug fixes: last-checked time accuracy, UTC uptime calculation, URL validation, safe unwrap, settings key constants

## [0.0.6] - 2026-03-05

### Fixed
- Code review fixes: semantic version comparison, local hotkey monitor, dead code cleanup

## [0.0.5] - 2026-03-05

### Added
- Per-service notification mute: toggle alerts for individual services in Settings
- Incident duration display: ongoing incidents show "2h 30m ongoing", resolved show total duration
- Uptime bar date tooltips: hover each day to see date + status (e.g., "3/4 — Operational")
- Global hotkey (Cmd+Shift+C) to toggle the popover from anywhere
- In-app incident detail: click to expand/collapse incident updates inline (browser link preserved)
- Configurable refresh interval: 15s / 30s / 1m / 5m picker in Settings
- Auto update check: checks GitHub Releases on launch, shows banner if new version available

### Changed
- Timer.scheduledTimer replaced with Task.sleep loop for clean cancellation
- Network monitoring via NWPathMonitor — skips API calls when offline, refreshes immediately on reconnect
- App termination now calls stop() via willTerminateNotification — prevents resource leaks
- Error logging with os_log (Logger) in StatusService for diagnostics
- Uptime calculation moved from StatusMonitor (main thread) to StatusService (actor) for better performance
- All hardcoded constants (URLs, intervals, cache TTL) consolidated into AppConstants.swift

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
