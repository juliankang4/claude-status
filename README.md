# Claude Status

macOS 메뉴바에서 Claude 서비스 상태를 실시간으로 확인하는 네이티브 앱.

![macOS](https://img.shields.io/badge/macOS-14%2B-blue) ![Swift](https://img.shields.io/badge/Swift-6-orange) ![License](https://img.shields.io/badge/License-MIT-green)

## 기능

- **실시간 모니터링** — 15초마다 자동 갱신
- **메뉴바 아이콘** — ☁️✅(정상), ☁️⚠️(경미), ☁️❌(심각), ☁️❓(오프라인)
- **서비스 상태** — claude.ai, platform, API, Claude Code, Government
- **30일 업타임 바** — 각 서비스별 시각적 히스토리
- **최근 장애** — 최근 5건, 클릭 시 브라우저에서 상세 확인
- **오프라인 캐시** — 인터넷 연결 실패 시 캐시 데이터 표시
- **알림** — 상태 변경 시 macOS 알림 (켜기/끄기 가능)
- **다국어** — 한국어/영어 전환
- **시작프로그램** — 로그인 시 자동 실행 (켜기/끄기 가능)
- **Dock 숨김** — Dock과 Cmd+Tab에 표시되지 않음

## 설치

### 빌드 (Xcode 불필요)

```bash
git clone https://github.com/julianyoon/claude-status-app.git
cd claude-status-app
./Scripts/build.sh
```

빌드된 앱: `Build/Claude Status.app`

### /Applications에 설치

```bash
./Scripts/build.sh --install
```

### 실행

```bash
./Scripts/run.sh
```

또는 `Build/Claude Status.app`을 더블클릭.

## 요구사항

- macOS 14 (Sonoma) 이상
- Swift 6+ (Command Line Tools)
- 외부 의존성 없음

## 데이터 소스

- [status.claude.com](https://status.claude.com) — Anthropic 공식 상태 페이지 API

## 라이선스

MIT License — [LICENSE](LICENSE) 참고

## 변경 이력

### v0.0.0 (2026-03-05)
- 최초 릴리스
- SwiftBar 셸 스크립트를 네이티브 Swift/SwiftUI 앱으로 재구현
