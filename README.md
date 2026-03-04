# Claude Status

A native macOS menu bar app that monitors Claude service status in real time.

![macOS](https://img.shields.io/badge/macOS-14%2B-blue) ![Swift](https://img.shields.io/badge/Swift-6-orange) ![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Real-time monitoring** — Auto-refreshes every 15 seconds
- **Menu bar icon** — Claude logo with status dot (green/orange/red/gray)
- **Service status** — claude.ai, platform, API, Claude Code, Government
- **30-day uptime bar** — Visual history for each service
- **Recent incidents** — Latest 5 incidents, click to open in browser
- **Offline cache** — Shows cached data when internet is unavailable
- **Notifications** — macOS alerts on status changes (toggle on/off)
- **Bilingual** — English / Korean
- **Launch at Login** — Auto-start on login (toggle on/off)
- **Hidden from Dock** — No Dock icon or Cmd+Tab entry

## Installation

### Build (No Xcode required)

```bash
git clone https://github.com/juliankang4/claude-status.git
cd claude-status
./Scripts/build.sh
```

Output: `Build/Claude Status.app`

### Install to /Applications

```bash
./Scripts/build.sh --install
```

### Run

```bash
./Scripts/run.sh
```

Or double-click `Build/Claude Status.app`.

## Requirements

- macOS 14 (Sonoma) or later
- Swift 6+ (Command Line Tools)
- No external dependencies

## Data Source

- [status.claude.com](https://status.claude.com) — Anthropic's official status page API

## License

MIT License — See [LICENSE](LICENSE)

## Changelog

### v0.0.0 (2026-03-05)
- Initial release
- Native Swift/SwiftUI rewrite of SwiftBar shell script

---

## 한국어

macOS 메뉴바에서 Claude 서비스 상태를 실시간으로 확인하는 네이티브 앱입니다.

### 기능

- **실시간 모니터링** — 15초마다 자동 갱신
- **메뉴바 아이콘** — Claude 로고 + 상태 점 (초록/주황/빨강/회색)
- **서비스 상태** — claude.ai, platform, API, Claude Code, Government
- **30일 업타임 바** — 각 서비스별 시각적 히스토리
- **최근 장애** — 최근 5건, 클릭 시 브라우저에서 상세 확인
- **오프라인 캐시** — 인터넷 연결 실패 시 캐시 데이터 표시
- **알림** — 상태 변경 시 macOS 알림 (켜기/끄기 가능)
- **다국어** — 한국어/영어 전환
- **시작프로그램** — 로그인 시 자동 실행 (켜기/끄기 가능)
- **Dock 숨김** — Dock과 Cmd+Tab에 표시되지 않음

### 설치

```bash
git clone https://github.com/juliankang4/claude-status.git
cd claude-status
./Scripts/build.sh          # 빌드
./Scripts/build.sh --install # /Applications에 설치
./Scripts/run.sh             # 빌드 + 실행
```

### 요구사항

- macOS 14 (Sonoma) 이상
- Swift 6+ (Command Line Tools)
- 외부 의존성 없음
