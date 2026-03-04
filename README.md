# Claude Status

A native macOS menu bar app that monitors Claude service status in real time.

![macOS](https://img.shields.io/badge/macOS-14%2B-blue) ![Swift](https://img.shields.io/badge/Swift-6-orange) ![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Real-time monitoring** — Auto-refreshes (configurable: 15s / 30s / 1m / 5m)
- **Menu bar icon** — Claude logo with status dot (green/orange/red/gray)
- **Service status** — claude.ai, platform, API, Claude Code, Government
- **30-day uptime bar** — Visual history with date tooltips on hover
- **Recent incidents** — Latest 5, expandable in-app detail with duration display
- **Per-service alerts** — Mute notifications for specific services
- **Keyboard shortcut** — Cmd+Shift+C to toggle popover
- **Offline cache** — Shows cached data when internet is unavailable
- **Network-aware** — Skips API calls when offline, refreshes on reconnect
- **Auto-update check** — Checks GitHub Releases on launch
- **Notifications** — macOS alerts on status changes (toggle on/off)
- **Bilingual** — English / Korean
- **Launch at Login** — Auto-start on login (toggle on/off)
- **Hidden from Dock** — No Dock icon or Cmd+Tab entry

## Installation

### Homebrew (Recommended)

```bash
brew tap juliankang4/tap
brew install claude-status
```

### Download

Download the latest `.app.zip` from [Releases](https://github.com/juliankang4/claude-status/releases), unzip, and move to `/Applications/`.

### Build from source (No Xcode required)

```bash
git clone https://github.com/juliankang4/claude-status.git
cd claude-status
./Scripts/build.sh --install
```

## Requirements

- macOS 14 (Sonoma) or later
- Apple Silicon (arm64)
- For building from source: Swift 6+ (Command Line Tools)

## Data Source

- [status.claude.com](https://status.claude.com) — Anthropic's official status page API

## License

MIT License — See [LICENSE](LICENSE)

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

---

## 한국어

macOS 메뉴바에서 Claude 서비스 상태를 실시간으로 확인하는 네이티브 앱입니다.

### 기능

- **실시간 모니터링** — 자동 갱신 (설정 가능: 15초/30초/1분/5분)
- **메뉴바 아이콘** — Claude 로고 + 상태 점 (초록/주황/빨강/회색)
- **서비스 상태** — claude.ai, platform, API, Claude Code, Government
- **30일 업타임 바** — 각 서비스별 시각적 히스토리, 호버 시 날짜 툴팁
- **최근 장애** — 최근 5건, 클릭 시 인앱 상세 확인 + 지속 시간 표시
- **서비스별 알림** — 특정 서비스 알림 끄기 가능
- **키보드 단축키** — Cmd+Shift+C로 팝오버 열기/닫기
- **오프라인 캐시** — 인터넷 연결 실패 시 캐시 데이터 표시
- **네트워크 감지** — 오프라인 시 API 호출 건너뛰기, 복구 시 즉시 갱신
- **자동 업데이트 확인** — 시작 시 GitHub에서 새 버전 확인
- **알림** — 상태 변경 시 macOS 알림 (켜기/끄기 가능)
- **다국어** — 한국어/영어 전환
- **시작프로그램** — 로그인 시 자동 실행 (켜기/끄기 가능)
- **Dock 숨김** — Dock과 Cmd+Tab에 표시되지 않음

### 설치

```bash
# Homebrew (추천)
brew tap juliankang4/tap
brew install claude-status

# 또는 소스에서 빌드
git clone https://github.com/juliankang4/claude-status.git
cd claude-status
./Scripts/build.sh --install
```

또는 [Releases](https://github.com/juliankang4/claude-status/releases)에서 `.app.zip` 다운로드.

### 요구사항

- macOS 14 (Sonoma) 이상
- Apple Silicon (arm64)
