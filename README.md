# 🗳 Gollaba

> 사진 기반 투표를 만들고, 공유하고, 참여하는 iOS 앱
> **App Store 배포 완료** · iOS 16.0+ · Swift 5.9

<br>

## 📱 화면 구성

| 홈 | 투표 상세 | 투표 생성 | 검색 | 마이페이지 |
|:---:|:---:|:---:|:---:|:---:|
| 인기/최신 투표 목록 | 투표 참여 및 결과 확인 | 항목별 이미지 첨부 | 실시간 검색 및 필터 | 내가 만든/참여한/좋아요 투표 |

<br>

## ⚙️ 기술 스택

| 분류 | 사용 기술 |
|------|-----------|
| **언어** | Swift 5.9 |
| **UI** | SwiftUI |
| **아키텍처** | Clean Architecture (Presentation / Domain / Data) |
| **비동기** | Swift Concurrency (async/await) |
| **네트워크** | Alamofire (RequestInterceptor로 JWT 자동 갱신) |
| **로컬 저장** | SwiftData, Keychain |
| **인증** | OAuth 2.0 (카카오, 애플, 구글, 네이버, 깃허브) |
| **푸시 알림** | FCM (Firebase Cloud Messaging) |
| **이미지** | Kingfisher |
| **딥링크** | Universal Links |
| **테스트** | XCTest (Unit Test) |

<br>

## 🏗 아키텍처

MVVM에서 UseCase와 Repository 레이어를 추가한 **Clean Architecture**를 채택했습니다.
ViewModel이 네트워크 구현체를 직접 참조하지 않아 **테스트 가능성**과 **변경 격리**가 확보됩니다.

```
┌─────────────────────────────────────────────────────┐
│                   Presentation                      │
│  View (SwiftUI)  ←→  ViewModel (@Observable)        │
│                       ↓ Protocol                    │
├─────────────────────────────────────────────────────┤
│                     Domain                          │
│            UseCase (비즈니스 로직)                    │
│                       ↓ Protocol                    │
├─────────────────────────────────────────────────────┤
│                      Data                           │
│          Repository (데이터 접근 추상화)               │
│                       ↓                             │
│   ApiManager │ SwiftData │ KeychainManager          │
└─────────────────────────────────────────────────────┘
```

### 의존성 방향

```
View → ViewModel → UseCaseProtocol ← UseCase → RepositoryProtocol ← Repository → ApiManager
```

- ViewModel은 `UseCaseProtocol`만 알고, 구현체(`UseCase`)는 모름
- UseCase는 `RepositoryProtocol`만 알고, 구현체(`Repository`)는 모름
- 테스트 시 Mock 객체로 교체 가능

<br>

## 📂 프로젝트 구조

```
Gollaba/
├── Presentation/
│   └── Screens/
│       ├── Home/           # 홈 화면 (인기 투표, 오늘의 투표)
│       ├── PollDetail/     # 투표 상세 (참여, 결과, 수정, 철회)
│       ├── CreatePoll/     # 투표 생성
│       ├── Search/         # 검색 및 결과 목록
│       ├── MyPoll/         # 마이페이지 (만든/참여한/좋아요 투표)
│       ├── Notification/   # 알림 내역
│       ├── Setting/        # 설정 (프로필, 닉네임, 알림)
│       ├── Login/          # OAuth 로그인
│       └── SignUp/         # 회원가입
├── Data/
│   ├── Network/
│   │   └── ApiManager.swift    # Alamofire 네트워크 레이어
│   ├── UseCase/                # 비즈니스 로직 (Protocol + Impl)
│   ├── Repository/             # 데이터 접근 추상화 (Protocol + Impl)
│   └── Error/
│       └── NetworkError.swift  # 에러 타입 통일
└── Manager/
    ├── ApiInterceptor.swift    # JWT 자동 갱신
    ├── AuthManager.swift       # 인증 상태 관리
    └── KeychainManager.swift   # 토큰 보안 저장
```

<br>

## 🧪 테스트

프로토콜 기반 의존성 주입으로 Mock 객체를 활용한 단위 테스트를 작성했습니다.

```
GollabaTests/
├── Mocks/
│   ├── MockPollsUseCase.swift
│   ├── MockFavoriteUseCase.swift
│   └── MockUserUseCase.swift
├── UseCases/
│   ├── PollsUseCaseTests.swift
│   └── UserUseCaseTests.swift
└── ViewModels/
    ├── HomeViewModelTests.swift
    └── MyPollViewModelTests.swift
```

**테스트 예시 — ViewModel이 UseCase의 실제 구현체 없이 동작하는지 검증**

```swift
func test_getPollsCreatedByMe_성공시_목록_설정됨() async {
    // given
    let items = [PollItem.mockData(), PollItem.mockData()]
    mockPollsUseCase.getPollsCreatedByMeResult = .success(.make(items: items))

    // when
    await sut.getPollsCreatedByMe()

    // then
    XCTAssertEqual(sut.createdByMePollList.count, 2)
    XCTAssertFalse(sut.showErrorDialog)
}
```

<br>

## 🔥 기술적 고민 및 트러블슈팅

### 1. JWT 토큰 자동 갱신

**문제** : 401 응답 시 모든 API 호출 지점에서 토큰 갱신 로직을 반복 작성해야 했습니다.

**해결** : Alamofire의 `RequestInterceptor`를 구현한 `ApiInterceptor`를 세션에 등록했습니다.
401 응답이 오면 `retry()` 메서드에서 토큰을 갱신하고 원래 요청을 자동으로 재시도합니다.
갱신 실패 시 세션 만료 처리를 한 곳에서 일관되게 수행합니다.

```swift
func retry(_ request: Request, for session: Session, dueTo error: Error,
           completion: @escaping (RetryResult) -> Void) {
    guard (request.task?.response as? HTTPURLResponse)?.statusCode == 401 else {
        completion(.doNotRetryWithError(error))
        return
    }
    ApiManager.shared.refreshToken { result in
        switch result {
        case .success(let newToken):
            ApiManager.shared.authManager?.jwtToken = newToken
            completion(.retry)   // 원래 요청 재시도
        case .failure:
            ApiManager.shared.authManager?.logout()
            completion(.doNotRetryWithError(error))
        }
    }
}
```

---

### 2. 레이어 간 에러 타입 불일치

**문제** : 초기 구조에서 `ApiError`, `AuthError`, `VotingError` 등 여러 에러 타입이 혼재해,
Presentation 레이어까지 Data 레이어 내부 타입이 노출되는 문제가 있었습니다.

**해결** : `NetworkError` 하나로 통일하고 `static` 상수로 특수 상태값을 표현했습니다.
ViewModel은 `NetworkError`만 다루게 되어 레이어 간 결합도가 낮아졌습니다.

```swift
// Before
if case .requestFailed(let status) = error,
   status == AuthError.notSignUp.rawValue { ... }   // Data 레이어 타입 노출

// After
if case .requestFailed(let status) = error,
   status == NetworkError.notSignUpStatus { ... }   // Presentation 레이어에서 안전하게 처리
```

---

### 3. Alamofire 콜백 → async/await 변환 보일러플레이트

**문제** : Alamofire는 클로저 기반 API를 제공하는데, 모든 메서드마다 `withCheckedContinuation` 블록을 반복 작성하면 30개 이상의 메서드에서 동일한 패턴이 중복됩니다.

**해결** : 제네릭 헬퍼 `request<T: Decodable>` 를 만들어 공통 로직을 단일 지점으로 수렴시켰습니다.
각 API 메서드는 URL과 파라미터만 구성하고, `Result.map` / `flatMap`으로 응답을 변환합니다.

```swift
// Before: 메서드마다 30줄 반복
return await withCheckedContinuation { continuation in
    session.request(url, ...).responseDecodable(of: AllPollResponse.self) { response in
        switch response.result {
        case .success(let value): continuation.resume(returning: .success(value.data))
        case .failure: continuation.resume(returning: .failure(...))
        }
    }
}

// After: 3줄로 압축
func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
    let url = getUrl(for: baseURL + "/v2/polls/me?...")
    return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
        .flatMap { (response: AllPollResponse) in .success(response.data) }
}
```

<br>

## 📦 의존성

| 라이브러리 | 관리 도구 | 용도 |
|-----------|----------|------|
| Alamofire | CocoaPods | 네트워크 요청 |
| Kingfisher | SPM | 이미지 캐싱 |
| AlertToast | CocoaPods | 토스트 메시지 UI |
| Firebase | SPM | FCM 푸시 알림 |
| KakaoSDK | SPM | 카카오 OAuth |

<br>

## 🚀 빌드 및 실행

```bash
# 의존성 설치
pod install

# 빌드는 반드시 .xcworkspace 사용
open Gollaba.xcworkspace
```

> `Gollaba.xcodeproj`로 열면 CocoaPods 의존성(Alamofire, AlertToast)을 찾지 못합니다.
