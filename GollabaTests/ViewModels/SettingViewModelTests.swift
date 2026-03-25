@testable import Gollaba
import UIKit
import XCTest

@MainActor
final class SettingViewModelTests: XCTestCase {
    private var sut: SettingViewModel!
    private var mockUserUseCase: MockUserUseCase!
    private var mockPushNotificationUseCase: MockPushNotificationUseCase!

    override func setUp() {
        super.setUp()
        mockUserUseCase = MockUserUseCase()
        mockPushNotificationUseCase = MockPushNotificationUseCase()
        sut = SettingViewModel(
            pushNotificationUseCase: mockPushNotificationUseCase,
            userUseCase: mockUserUseCase
        )
    }

    override func tearDown() {
        sut = nil
        mockUserUseCase = nil
        mockPushNotificationUseCase = nil
        super.tearDown()
    }

    // MARK: - showPHPicker 초기값

    func test_showPHPicker_초기값은_false() {
        XCTAssertFalse(sut.showPHPicker)
    }

    // MARK: - profileImage didSet

    func test_profileImage_설정시_updateUserProfileImage_호출됨() async {
        // given
        mockUserUseCase.updateProfileImageResult = .success(())
        mockUserUseCase.getUserMeResult = .success(.mock)

        // when
        sut.profileImage = UIImage()

        // didSet 내 Task 완료 대기
        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        XCTAssertEqual(mockUserUseCase.updateUserProfileImageCallCount, 1)
    }

    func test_profileImage_설정시_getUser_호출됨() async {
        // given
        mockUserUseCase.updateProfileImageResult = .success(())
        mockUserUseCase.getUserMeResult = .success(.mock)

        // when
        sut.profileImage = UIImage()

        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        XCTAssertEqual(mockUserUseCase.getUserMeCallCount, 1)
    }

    func test_profileImage_nil설정시_updateUserProfileImage_호출안됨() async {
        // when
        sut.profileImage = nil

        try? await Task.sleep(nanoseconds: 100_000_000)

        // then
        XCTAssertEqual(mockUserUseCase.updateUserProfileImageCallCount, 0)
    }

    func test_updateProfileImage_실패시_showErrorDialog_true() async {
        // given
        sut.profileImage = UIImage()
        mockUserUseCase.updateProfileImageResult = .failure(.requestFailed("이미지 업로드 실패"))

        // when
        await sut.updateProfileImage()

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "이미지 업로드 실패")
    }
}
