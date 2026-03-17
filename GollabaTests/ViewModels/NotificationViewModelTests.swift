@testable import Gollaba
import XCTest

@MainActor
final class NotificationViewModelTests: XCTestCase {
    private var sut: NotificationViewModel!
    private var mockUseCase: MockPushNotificationUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockPushNotificationUseCase()
        sut = NotificationViewModel(pushNotificationUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // MARK: - loadPushNotifications (isRefresh: true)

    func test_loadPushNotifications_refresh_성공시_데이터_설정됨() async {
        // given
        let items = [PushNotificationData.mock(id: 1), PushNotificationData.mock(id: 2)]
        mockUseCase.getPushNotificationHistoryResult = .success(.make(items: items))

        // when
        await sut.loadPushNotifications(isRefresh: true)

        // then
        XCTAssertEqual(sut.pushNotificationData?.items.count, 2)
        XCTAssertFalse(sut.showErrorDialog)
    }

    func test_loadPushNotifications_refresh_실패시_showErrorDialog_true() async {
        // given
        mockUseCase.getPushNotificationHistoryResult = .failure(.requestFailed("서버 오류"))

        // when
        await sut.loadPushNotifications(isRefresh: true)

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "서버 오류")
    }

    // MARK: - pagination & isEnd

    func test_loadPushNotifications_isEnd이면_API_호출안함() async {
        // given - 1건 로드 (items.count == totalCount → isEnd = true)
        let items = [PushNotificationData.mock()]
        mockUseCase.getPushNotificationHistoryResult = .success(.make(items: items))
        await sut.loadPushNotifications(isRefresh: true)
        let callCount = mockUseCase.getPushNotificationHistoryCallCount

        // when
        await sut.loadPushNotifications()

        // then
        XCTAssertEqual(mockUseCase.getPushNotificationHistoryCallCount, callCount)
    }

    func test_loadPushNotifications_pagination_기존목록에_추가됨() async {
        // given - 첫 로드 2건, totalCount=4 (isEnd = false)
        let firstItems = [PushNotificationData.mock(id: 1), PushNotificationData.mock(id: 2)]
        mockUseCase.getPushNotificationHistoryResult = .success(.make(items: firstItems, totalCount: 4))
        await sut.loadPushNotifications(isRefresh: true)

        let nextItems = [PushNotificationData.mock(id: 3), PushNotificationData.mock(id: 4)]
        mockUseCase.getPushNotificationHistoryResult = .success(.make(items: nextItems, totalCount: 4))

        // when
        await sut.loadPushNotifications()

        // then
        XCTAssertEqual(sut.pushNotificationData?.items.count, 4)
    }

    // MARK: - resetPage

    func test_resetPage_호출시_상태_초기화() async {
        // given
        let items = [PushNotificationData.mock()]
        mockUseCase.getPushNotificationHistoryResult = .success(.make(items: items))
        await sut.loadPushNotifications(isRefresh: true)

        // when
        sut.resetPage()

        // then
        XCTAssertNil(sut.pushNotificationData)
        XCTAssertEqual(sut.pushNotificationListPage, 0)
        XCTAssertFalse(sut.pushNotificationListIsEnd)
    }

    // MARK: - handleError

    func test_handleError_호출시_에러메시지와_다이얼로그_설정됨() {
        // when
        sut.handleError(error: .requestFailed("에러 발생"))

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "에러 발생")
    }
}
