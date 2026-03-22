Gollaba 프로젝트를 빌드하세요.

다음 명령어를 실행하세요:
```
xcodebuild build -workspace Gollaba.xcworkspace -scheme Gollaba -destination 'platform=iOS Simulator,id=DF383E55-25D0-4CC1-874E-66D30C7AADB0' 2>&1 | grep -E "error:|warning:|BUILD (SUCCEEDED|FAILED)"
```

- BUILD SUCCEEDED면 성공 알림
- error가 있으면 에러 내용을 분석하고 원인과 수정 방법을 설명
