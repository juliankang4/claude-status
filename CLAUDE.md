# Claude Status App

## 프로젝트 개요
macOS 메뉴바에서 Claude 서비스 상태를 실시간 확인하는 네이티브 Swift/SwiftUI 앱.
기존 SwiftBar 셸 스크립트(`~/build/claude-status/`)를 네이티브로 재구현.

## 빌드 방법
```bash
# 빌드만
./Scripts/build.sh

# 빌드 + 실행
./Scripts/run.sh
```

## 구조
```
Sources/ClaudeStatus/
├── ClaudeStatusApp.swift       # @main, MenuBarExtra
├── Models/                     # Codable 모델
├── Services/                   # API, 알림
├── ViewModels/                 # StatusMonitor
├── Views/                      # SwiftUI 뷰
├── Localization/               # 한/영 문자열
└── Utilities/                  # 매핑, 포맷팅
```

## 데이터 소스
- `https://status.claude.com/api/v2/summary.json`
- `https://status.claude.com/api/v2/incidents.json`

## 핵심 규칙
- macOS 14+ 타겟 (Sonoma)
- Swift 6 strict concurrency 준수
- MenuBarExtra(.window) 스타일
- Info.plist: LSUIElement=true (Dock 숨김)
- ProcessInfo.beginActivity() 로 App Nap 방지
- 15초 자동갱신
- 의존성 없음 (SPM 외부 패키지 사용 금지)
