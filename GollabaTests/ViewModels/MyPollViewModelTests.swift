@testable import Gollaba
import XCTest

@MainActor
final class MyPollViewModelTests: XCTestCase {
    private var sut: MyPollViewModel!
    private var mockPollsUseCase: MockPollsUseCase!
    private var mockFavoriteUseCase: MockFavoriteUseCase!
    private var mockUserUseCase: MockUserUseCase!
    private var mockPushNotificationUseCase: MockPushNotificationUseCase!

    override func setUp() {
        super.setUp()
        mockPollsUseCase = MockPollsUseCase()
        mockFavoriteUseCase = MockFavoriteUseCase()
        mockUserUseCase = MockUserUseCase()
        mockPushNotificationUseCase = MockPushNotificationUseCase()
        sut = MyPollViewModel(
            pollsUseCase: mockPollsUseCase,
            favoriteUseCase: mockFavoriteUseCase,
            pushNotificationUseCase: mockPushNotificationUseCase,
            userUseCase: mockUserUseCase
        )
    }

    override func tearDown() {
        sut = nil
        mockPollsUseCase = nil
        mockFavoriteUseCase = nil
        mockUserUseCase = nil
        super.tearDown()
    }

    // MARK: - getPollsCreatedByMe

    func test_getPollsCreatedByMe_성공시_목록_설정됨() async {
        // given
        let items = [PollItem.mockData(), PollItem.mockData()]
        mockPollsUseCase.getPollsCreatedByMeResult = .success(.make(items: items))
        let authManager = AuthManager()
        authManager.jwtToken = "test-token"
        sut.setAuthManager(authManager)

        // when
        await sut.getPollsCreatedByMe()

        // then
        XCTAssertEqual(sut.createdByMePollList.count, 2)
        XCTAssertFalse(sut.showErrorDialog)
    }

    func test_getPollsCreatedByMe_이미데이터있으면_스킵() async {
        // given
        let items = [PollItem.mockData()]
        mockPollsUseCase.getPollsCreatedByMeResult = .success(.make(items: items))
        let authManager = AuthManager()
        authManager.jwtToken = "test-token"
        sut.setAuthManager(authManager)
        await sut.getPollsCreatedByMe() // 첫 호출

        // when
        await sut.getPollsCreatedByMe() // 두 번째 호출

        // then - 데이터가 있으면 API를 다시 호출하지 않음
        XCTAssertEqual(sut.createdByMePollList.count, 1)
    }

    // MARK: - createFavorite

    func test_createFavorite_성공시_에러없음() async {
        // given
        mockFavoriteUseCase.createFavoriteResult = .success(())

        // when
        await sut.createFavorite(pollHashId: "test-hash")

        // then
        XCTAssertFalse(sut.showErrorDialog)
        XCTAssertEqual(mockFavoriteUseCase.createFavoriteCallCount, 1)
        XCTAssertEqual(mockFavoriteUseCase.lastCreatedHashId, "test-hash")
    }

    func test_createFavorite_실패시_showErrorDialog_true() async {
        // given
        mockFavoriteUseCase.createFavoriteResult = .failure(.requestFailed("즐겨찾기 실패"))

        // when
        await sut.createFavorite(pollHashId: "test-hash")

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "즐겨찾기 실패")
    }

    // MARK: - deleteFavorite

    func test_deleteFavorite_성공시_에러없음() async {
        // given
        mockFavoriteUseCase.deleteFavoriteResult = .success(())

        // when
        await sut.deleteFavorite(pollHashId: "test-hash")

        // then
        XCTAssertFalse(sut.showErrorDialog)
        XCTAssertEqual(mockFavoriteUseCase.lastDeletedHashId, "test-hash")
    }

    // MARK: - reset

    func test_resetPollsCreatedByMe_목록과_페이지_초기화() async {
        // given
        let items = [PollItem.mockData()]
        mockPollsUseCase.getPollsCreatedByMeResult = .success(.make(items: items))
        sut.authManager = AuthManager()
        sut.authManager?.jwtToken = "test-token"
        await sut.getPollsCreatedByMe()

        // when
        sut.resetPollsCreatedByMe()

        // then
        XCTAssertTrue(sut.createdByMePollList.isEmpty)
        XCTAssertFalse(sut.createdByMePollIsEnd)
    }

    // MARK: - selectedTab

    func test_selectedTab_변경시_currentTabHeight_업데이트() {
        // given
        sut.madeByMeTabHeight = 300
        sut.favoriteByMeTabHeight = 500
        sut.participatedTabHeight = 400

        // when
        sut.selectedTab = .favoriteByMe
        sut.updateCurrentTabHeight()

        // then
        XCTAssertEqual(sut.currentTabHeight, 500)
    }
}
