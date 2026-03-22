# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# 빌드 (반드시 .xcworkspace 사용 — CocoaPods 의존성 포함)
xcodebuild build \
  -workspace Gollaba.xcworkspace \
  -scheme Gollaba \
  -destination 'platform=iOS Simulator,id=DF383E55-25D0-4CC1-874E-66D30C7AADB0'

# 전체 테스트 실행
xcodebuild test \
  -workspace Gollaba.xcworkspace \
  -scheme Gollaba \
  -destination 'platform=iOS Simulator,id=DF383E55-25D0-4CC1-874E-66D30C7AADB0' \
  -only-testing:GollabaTests

# 특정 테스트 클래스만 실행
xcodebuild test \
  -workspace Gollaba.xcworkspace \
  -scheme Gollaba \
  -destination 'platform=iOS Simulator,id=DF383E55-25D0-4CC1-874E-66D30C7AADB0' \
  -only-testing:GollabaTests/HomeViewModelTests
```

## Architecture

```
Presentation (View + ViewModel)
    ↓ UseCaseProtocol
Domain (UseCase + Repository Protocol)
    ↓ Repository (Protocol)
Data (DefaultRepository + ApiManager)
```

- **ViewModel** — `@Observable` 사용 (`@MainActor` 없음). async 함수는 View의 `.task {}` / `Task {}` 에서 호출.
- **UseCase** — `XxxUseCaseProtocol` + `XxxUseCase` 구현체. `Data/UseCase/`에 위치. `NetworkError`를 반환.
- **Repository Protocol** — `Domain/Repository/`에 위치. (`XxxRepository` 이름, Protocol 키워드 없이 프로토콜).
- **Repository 구현체** — `Data/Repository/DefaultXxxRepository`. ApiManager를 직접 호출.
- **DI** — `Data/DI/AppContainer.swift` (Factory 라이브러리). UseCase는 singleton 스코프, ViewModel은 per-call. 런타임 파라미터가 필요한 ViewModel은 `ParameterFactory` 사용.

## Key Files

| 파일 | 역할 |
|---|---|
| `Data/DI/AppContainer.swift` | 전체 의존성 등록 (Factory) |
| `Data/Network/ApiManager.swift` | Alamofire 기반 네트워크 레이어 (1400+ 줄) |
| `Manager/AuthManager.swift` | JWT 토큰, 로그인 상태, 소셜 인증 관리 (`@Observable`) |
| `Manager/ApiInterceptor.swift` | JWT 토큰 자동 갱신 (Alamofire RequestInterceptor) |
| `Data/Error/NetworkError.swift` | Presentation → UseCase 간 통일 에러 타입 |
| `Entity/ValidationConstants.swift` | 닉네임 금지어, 특수문자 정규식 공통 상수 |

## Error Handling

UseCase는 `Result<T, NetworkError>`를 반환. ViewModel은 항상 `handleError(error: NetworkError)` 로 처리.

- `NetworkError.notSignUpStatus` — `"NOT_SIGN_UP"` (미가입 분기)
- `NetworkError.alreadyVotedStatus` — `"ALREADY_VOTING"` (중복 투표 분기)

ApiManager 내부 에러(`ApiError`, `AuthError`, `VotingError`)는 UseCase 단에서 `NetworkError`로 변환. Presentation은 내부 에러 타입을 알 필요 없음.

## Test Structure

- `GollabaTests/Mocks/` — `MockPollsUseCase`, `MockFavoriteUseCase`, `MockUserUseCase`, `MockPollRepository`, `MockUserRepository`
- `GollabaTests/UseCases/` — UseCase 단위 테스트
- `GollabaTests/ViewModels/` — ViewModel 단위 테스트

Mock은 프로토콜 기반(`XxxUseCaseProtocol`)으로 작성. 네트워크 없이 ViewModel 로직 검증.

## Xcode Project Notes

- `Manager/`, `Model/`, `Modifier/`, `Entity/`, `CustomView/` — `PBXFileSystemSynchronizedRootGroup` (파일 추가 시 자동 인식)
- `Common/`, `Extension/`, `Data/`, `Domain/`, `Presentation/` — `PBXGroup` (파일 추가 시 pbxproj에 명시적 등록 필요)
- 새 파일을 PBXGroup 폴더에 추가할 경우 xcodeproj gem으로 pbxproj 수정 필요

## 에이전트 및 커맨드 사용 규칙

**MUST**: 아래 규칙을 항상 따른다. 사용자가 별도로 지시하지 않아도 스스로 판단해서 실행한다.

| 요청 유형 | 반드시 사용할 도구 |
|---|---|
| 새 기능 설계 / 구조 결정 | `architect` agent (Task tool) |
| 새 파일 생성 / 기능 구현 | `implementer` agent (Task tool) |
| ViewModel · UseCase 테스트 작성 | `tester` agent (Task tool) |
| "커밋해줘" 또는 작업 완료 후 커밋 시 | `commit` skill (Skill tool) |
| 코드 리뷰 요청 | `review` skill (Skill tool) |
| "테스트 돌려줘" 또는 구현 완료 후 테스트 시 | `test` skill (Skill tool) |
| 새 기능 전체 구현 요청 | `new-feature` skill (Skill tool) |

- 설계가 필요한 작업 → architect → implementer → tester 순서로 agent를 순차 호출한다.
- 간단한 수정(버그 픽스, 1~2줄 변경)은 agent 없이 직접 처리해도 된다.
- 코드 변경을 완료한 뒤에는 항상 `build` skill로 빌드를 확인한다.

## Conventions

- 커밋 메시지에 `Co-Authored-By:` 절대 포함 금지
- 응답 언어: 한국어
