# 🗳 Gollaba

> 사진 기반 투표를 만들고, 공유하고, 참여하는 iOS 앱

![Swift](https://img.shields.io/badge/Swift-5.0-orange) ![iOS](https://img.shields.io/badge/iOS-18.0+-blue) ![Xcode](https://img.shields.io/badge/Xcode-26.0.1-lightgrey)

<br>

## 스크린샷

| 홈 | 검색 | 투표 생성 |
|:---:|:---:|:---:|
| <img src="Assets/screenshots/Home.gif" width="200"> | <img src="Assets/screenshots/Search.gif" width="200"> | <img src="Assets/screenshots/CreatePoll.gif" width="200"> |

| 로그인 투표 참여 | 비로그인 투표 참여 | 투표자 목록 |
|:---:|:---:|:---:|
| <img src="Assets/screenshots/Loggin_Voting.gif" width="200"> | <img src="Assets/screenshots/NotLoggin_Voting.gif" width="200"> | <img src="Assets/screenshots/VoterList.png" width="200"> |

| 좋아요 / 신고 | 마이페이지 | 프로필 수정 |
|:---:|:---:|:---:|
| <img src="Assets/screenshots/Like_Report.gif" width="200"> | <img src="Assets/screenshots/MyPoll.gif" width="200"> | <img src="Assets/screenshots/EditProfile.gif" width="200"> |

| 회원가입 | 푸쉬 알림 수신 | 알림 목록 |
|:---:|:---:|:---:|
| <img src="Assets/screenshots/SignUp.gif" width="200"> | <img src="Assets/screenshots/PushNoti.gif" width="200"> | <img src="Assets/screenshots/PushNotiList.gif" width="200"> |

<br>

## 주요 기능

| 기능 | 설명 |
|------|------|
| 홈 | 인기 투표, 오늘의 투표 목록 조회 |
| 투표 상세 | 투표 참여, 결과 확인, 참여 수정 및 철회, 투표자 목록 조회 |
| 투표 생성 | 항목별 이미지 첨부, 단일/복수 응답, 기명/익명 설정 |
| 검색 | 키워드 검색, 인기 검색어, 최근 검색어, 필터·정렬 |
| 마이페이지 | 내가 만든/참여한/좋아요한 투표 탭별 조회 |
| 알림 | FCM 푸쉬 알림 수신 및 알림 내역 조회 |
| 설정 | 프로필 이미지 변경, 닉네임 수정, 알림 on/off, 회원탈퇴 |
| 인증 | OAuth 소셜 로그인 (카카오, 애플, 구글, 네이버, 깃허브) |

<br>

## 기술 스택

| 분류 | 사용 기술 |
|------|----------|
| 언어 | Swift |
| UI | SwiftUI |
| 아키텍처 | MVVM + Clean Architecture |
| 비동기 | async/await, @MainActor |
| 네트워크 | Alamofire |
| 로컬 저장소 | SwiftData, Keychain |
| 인증 | OAuth 2.0 (카카오, 애플, 구글, 네이버, 깃허브) |
| 푸시 알림 | Firebase Cloud Messaging (FCM) |
| 이미지 | Kingfisher |
| 테스트 | XCTest |

<br>

## 아키텍처

```
Presentation
├── View (SwiftUI)
└── ViewModel (@Observable, @MainActor)

Domain
├── UseCases (Protocol + 구현체)
└── Repository Protocols

Data
├── Repositories (구현체)
└── Network (ApiManager, ApiInterceptor)
```

**Clean Architecture**

ViewModel이 `UseCaseProtocol`만 참조하고 구현체를 모르기 때문에, 테스트 시 Mock 객체로 교체할 수 있습니다. UseCase도 `RepositoryProtocol`만 참조해 네트워크·로컬 저장소 구현이 바뀌어도 비즈니스 로직에 영향이 없습니다.

**JWT 자동 갱신 (ApiInterceptor)**

Alamofire의 `RequestInterceptor`를 구현해 401 응답 시 토큰 갱신 후 원래 요청을 자동 재시도합니다. 갱신 실패 시 세션 만료 처리를 한 곳에서 일관되게 수행합니다. 모든 API 호출 지점에서 토큰 갱신 로직을 반복 작성할 필요가 없습니다.

<br>

## 기술적 의사결정

**Clean Architecture 도입**

초기에는 ViewModel이 `ApiManager`를 직접 호출했습니다. 이 구조에서는 네트워크 없이 ViewModel 로직을 테스트할 수 없고, API 변경 시 ViewModel까지 수정해야 했습니다. UseCase와 Repository 레이어를 프로토콜로 분리해 `MockPollsUseCase`, `MockUserUseCase` 등을 작성하고 네트워크 없이 단위 테스트를 작성할 수 있었습니다.

**Combine 대신 async/await**

투표 목록 로드나 투표 참여처럼 "한 번 요청하고 결과를 받는" 일회성 비동기 작업이 대부분입니다. 지속적인 이벤트 스트림이 필요한 경우가 적어 Combine의 Publisher/Subscriber 패턴보다 async/await가 더 직관적이고 코드가 간결했습니다. `@MainActor`로 UI 업데이트 스레드 안전성을 보장했습니다.

<br>

## 트러블슈팅

**레이어 간 에러 타입 불일치**

초기 구조에서 `ApiError`, `AuthError`, `VotingError` 등 Data 레이어 내부 타입이 Presentation 레이어까지 노출됐습니다. ViewModel에서 `AuthError.notSignUp.rawValue`를 직접 비교하는 코드가 생겨 레이어 분리 원칙이 무너졌습니다. `NetworkError` 하나로 통일하고 `static` 상수로 특수 상태값을 표현해 ViewModel이 Data 레이어 내부 타입을 모르도록 했습니다.

**Alamofire 콜백 → async/await 변환 보일러플레이트**

Alamofire는 클로저 기반 API를 제공하기 때문에 모든 메서드마다 `withCheckedContinuation` 블록을 작성하면 30개 이상의 메서드에서 동일한 패턴이 중복됐습니다. 제네릭 헬퍼 `request<T: Decodable>`를 만들어 공통 로직을 단일 지점으로 수렴시켰습니다. 각 API 메서드는 URL과 파라미터만 구성하고 `Result.map` / `flatMap`으로 응답을 변환하도록 했습니다.

<br>

## 프로젝트 구조

```
Gollaba/
├── Presentation/
│   └── Screens/
│       ├── Home/           # 홈 (인기 투표, 오늘의 투표)
│       ├── PollDetail/     # 투표 상세 (참여, 결과, 수정, 철회)
│       ├── CreatePoll/     # 투표 생성
│       ├── Search/         # 검색 및 결과 목록
│       ├── MyPoll/         # 마이페이지
│       ├── Notification/   # 알림 내역
│       ├── Setting/        # 설정
│       ├── Login/          # OAuth 로그인
│       └── SignUp/         # 회원가입
├── Data/
│   ├── Network/
│   │   └── ApiManager.swift    # Alamofire 네트워크 레이어
│   ├── UseCase/                # 비즈니스 로직 (Protocol + 구현체)
│   ├── Repository/             # 데이터 접근 추상화 (Protocol + 구현체)
│   └── Error/
│       └── NetworkError.swift  # 에러 타입 통일
└── Manager/
    ├── ApiInterceptor.swift    # JWT 자동 갱신
    ├── AuthManager.swift       # 인증 상태 관리
    └── KeychainManager.swift   # 토큰 보안 저장
```
