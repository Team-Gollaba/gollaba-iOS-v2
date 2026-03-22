GollabaTests 단위 테스트를 실행하세요.

인자가 있으면 해당 테스트 클래스만 실행하고, 없으면 전체 실행합니다.

전체 실행:
```
xcodebuild test -workspace Gollaba.xcworkspace -scheme Gollaba -destination 'platform=iOS Simulator,id=DF383E55-25D0-4CC1-874E-66D30C7AADB0' -only-testing:GollabaTests 2>&1 | grep -E "Test Case|error:|FAILED|Executed"
```

특정 클래스 실행 (예: $ARGUMENTS):
```
xcodebuild test -workspace Gollaba.xcworkspace -scheme Gollaba -destination 'platform=iOS Simulator,id=DF383E55-25D0-4CC1-874E-66D30C7AADB0' -only-testing:GollabaTests/$ARGUMENTS 2>&1 | grep -E "Test Case|error:|FAILED|Executed"
```

결과에서 실패한 테스트 케이스가 있으면 원인을 분석하세요.
