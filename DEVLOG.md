# DEVLOG — Claude Status App

## 2026-03-05: 초기 구현

### 구현한 기능
- MenuBarExtra(.window) 기반 메뉴바 앱
- StatusService (actor): URLSession async/await로 API 호출 + 파일 기반 오프라인 캐시
- StatusMonitor (@Observable, @MainActor): 15초 자동갱신, 변경 감지, 알림 트리거
- NotificationService (actor): UNUserNotificationCenter 기반 macOS 알림
- 전체 UI: 서비스 상태, 30일 업타임 바, 장애 목록, 설정
- 한국어/영어 전환, 시작프로그램 토글 (SMAppService)
- App Nap 방지: ProcessInfo.beginActivity()

### 기술 선택
- **Swift 6 strict concurrency**: actor (서비스), @MainActor (뷰모델/뷰)
- **@Observable**: SwiftUI 자동 업데이트, Combine 불필요
- **MenuBarExtra(.window)**: 풍부한 팝오버 UI (SwiftUI 뷰 직접 사용)
- **SPM + build.sh**: Xcode 없이 빌드 가능
- **Info.plist LSUIElement=true**: Dock에 표시되지 않음

### 발생한 문제
1. **switch 문 implicit return**: Swift 6에서 `guard` 이후 `switch`의 암시적 반환이 동작하지 않음 → 명시적 `return` 추가
2. **`.task` on Scene**: `.task`는 View 수정자이므로 Scene에서 사용 불가 → StatusContentView 내부에서 `.task` 사용

### 프로젝트 구조
```
Sources/ClaudeStatus/
├── ClaudeStatusApp.swift          # @main, MenuBarExtra
├── Models/
│   ├── StatusModels.swift         # summary.json Codable
│   ├── IncidentModels.swift       # incidents.json Codable
│   └── AppSettings.swift          # @Observable 설정
├── Services/
│   ├── StatusService.swift        # actor: API + 캐시
│   └── NotificationService.swift  # UNUserNotificationCenter
├── ViewModels/
│   └── StatusMonitor.swift        # 15초 갱신, 변경 감지
├── Views/
│   ├── StatusContentView.swift    # 메인 팝오버
│   ├── ServiceRowView.swift       # 서비스 행
│   ├── UptimeBarView.swift        # 30일 업타임 바
│   ├── IncidentSectionView.swift  # 장애 섹션
│   ├── IncidentRowView.swift      # 장애 행
│   ├── FooterView.swift           # 하단
│   └── SettingsSectionView.swift  # 설정
├── Localization/
│   └── Strings.swift              # 한/영 문자열
└── Utilities/
    ├── StatusMapping.swift        # 상태→아이콘/색상
    └── DateFormatting.swift       # 날짜 포맷
```
