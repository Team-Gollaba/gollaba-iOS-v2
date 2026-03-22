새 화면을 생성하세요. 화면 이름은 $ARGUMENTS 입니다.

다음 두 파일을 생성하세요:

**1. Gollaba/Presentation/Screens/{이름}/{이름}View.swift**
```swift
//
//  {이름}View.swift
//  Gollaba
//

import SwiftUI
import Factory

struct {이름}View: View {
    @State private var viewModel = Container.shared.{camelCase이름}ViewModel()

    var body: some View {
        Text("{이름}")
    }
}
```

**2. Gollaba/Presentation/Screens/{이름}/{이름}ViewModel.swift**
```swift
//
//  {이름}ViewModel.swift
//  Gollaba
//

import SwiftUI

@Observable
class {이름}ViewModel {
    // MARK: - Flag
    var showErrorDialog: Bool = false

    // MARK: - Error
    private(set) var errorMessage: String = ""

    // MARK: - Initialize
    init() {}

    // MARK: - ETC
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
```

파일 생성 후 AppContainer.swift에 ViewModel 팩토리도 추가하세요:
```swift
var {camelCase이름}ViewModel: Factory<{이름}ViewModel> {
    self { {이름}ViewModel() }
}
```

단, Xcode PBXGroup 폴더(`Presentation/`)에 추가하는 경우 pbxproj 등록도 필요합니다. xcodeproj gem으로 추가하세요.
