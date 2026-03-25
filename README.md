# Gollaba

> 사진 기반 투표를 만들고, 공유하고, 참여하는 iOS 소셜 투표 앱

![Swift](https://img.shields.io/badge/Swift-6.0-orange) ![iOS](https://img.shields.io/badge/iOS-18.0+-blue) ![Xcode](https://img.shields.io/badge/Xcode-26.0+-lightgrey)

[![App Store](https://img.shields.io/badge/App_Store-Download-0D96F6?logo=app-store&logoColor=white)](https://apps.apple.com/us/app/%EA%B3%A8%EB%9D%BC%EB%B0%94/id6742055187)

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
| 알림 | FCM 푸시 알림 수신 및 알림 내역 조회 |
| 설정 | 프로필 이미지 변경, 닉네임 수정, 알림 on/off, 회원탈퇴 |
| 인증 | OAuth 소셜 로그인 (카카오, 애플) |

<br>

## 기술 스택

| 분류 | 사용 기술 |
|------|----------|
| 언어 | Swift |
| UI | SwiftUI |
| 아키텍처 | MVVM + Clean Architecture |
| 상태 관리 | @Observable |
| 비동기 | async/await |
| 네트워크 | Alamofire |
| 로컬 저장소 | SwiftData, Keychain |
| 의존성 주입 | Factory (SPM) |
| 인증 | OAuth 2.0 (카카오, 애플) |
| 푸시 알림 | Firebase Cloud Messaging (FCM) |
| 이미지 | Kingfisher |
| 테스트 | XCTest |
| UI 라이브러리 | AlertToast (CocoaPods) |

<br>

## 아키텍처

```mermaid
%%{init: {'theme': 'neutral'}}%%
graph TB
    classDef pres fill:#bfdbfe,stroke:#3b82f6,color:#1e3a5f
    classDef dom  fill:#bbf7d0,stroke:#16a34a,color:#14532d
    classDef dat  fill:#fed7aa,stroke:#ea580c,color:#7c2d12

    subgraph Presentation["📱 Presentation Layer"]
        View["Views\n(SwiftUI)"]
        VM["ViewModels\n(@Observable)"]
        DI["DI Container\n(AppContainer / Factory)"]
        View --> VM
        DI -.->|의존성 주입| View
    end

    subgraph Domain["🏛️ Domain Layer (순수 Swift)"]
        UseCase["UseCases\n(Polls · User · Favorite\nVoting · Auth · PushNotification)"]
        RepoProtocol["Repository Protocols\n(PollRepository\nUserRepository 등)"]
        UseCase --> RepoProtocol
    end

    subgraph Data["🗄️ Data Layer"]
        Repo["Repositories\n(DefaultPollRepository\nDefaultUserRepository 등)"]
        Network["ApiManager\n(Alamofire)"]
        Repo --> Network
    end

    VM -->|"UseCase Protocol 호출\nResult<T, NetworkError>"| UseCase
    Repo -->|"Protocol 구현"| RepoProtocol

    class View,VM,DI pres
    class UseCase,RepoProtocol dom
    class Repo,Network dat
```

