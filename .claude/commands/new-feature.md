새 기능을 설계부터 구현, 테스트까지 완전히 구현하세요. 기능 설명은 $ARGUMENTS 입니다.

다음 순서를 반드시 따르세요:

## 1. architect agent — 설계
- Task tool로 `architect` agent 호출
- 레이어별 파일 목록, 인터페이스, 데이터 흐름 설계
- PBXGroup vs PBXFileSystemSynchronizedRootGroup 여부 판단

## 2. implementer agent — 구현
- Task tool로 `implementer` agent 호출
- architect 설계에 따라 파일 생성 및 AppContainer 등록
- PBXGroup 폴더라면 xcodeproj gem으로 pbxproj 등록 포함
- 구현 완료 후 `build` skill로 빌드 확인

## 3. tester agent — 테스트
- Task tool로 `tester` agent 호출
- ViewModel / UseCase 단위 테스트 작성 (Mock 기반)
- `test` skill로 테스트 실행 및 결과 확인

## 규칙
- 아키텍처: `Presentation → UseCase → Repository → ApiManager`
- ViewModel: `@Observable` 사용, `@MainActor` 없음
- UseCase: `Result<T, NetworkError>` 반환
- ViewModel 에러 처리: `handleError(error: NetworkError)`
- 커밋은 사용자가 별도로 요청할 때만 수행
