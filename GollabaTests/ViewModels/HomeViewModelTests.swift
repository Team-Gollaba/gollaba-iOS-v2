@testable import Gollaba
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {
    private var sut: HomeViewModel!
    private var mockUseCase: MockPollsUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockPollsUseCase()
        sut = HomeViewModel(pollsUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // MARK: - getPolls

    func test_getPolls_성공시_allPolls_설정됨() async {
        // given
        let items = [PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getPollsResult = .success(.make(items: items))

        // when
        await sut.getPolls()

        // then
        XCTAssertEqual(sut.allPolls?.items.count, 2)
        XCTAssertFalse(sut.showErrorDialog)
    }

    func test_getPolls_이미데이터있으면_API_호출안함() async {
        // given
        let items = [PollItem.mockData()]
        mockUseCase.getPollsResult = .success(.make(items: items))
        await sut.getPolls() // 첫 호출

        // when
        await sut.getPolls() // 두 번째 호출

        // then
        XCTAssertEqual(mockUseCase.getPollsCallCount, 1) // 한 번만 호출
    }

    func test_getPolls_실패시_showErrorDialog_true() async {
        // given
        mockUseCase.getPollsResult = .failure(.requestFailed("네트워크 오류"))

        // when
        await sut.getPolls()

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "네트워크 오류")
    }

    // MARK: - getTrendingPolls

    func test_getTrendingPolls_성공시_trendingPolls_설정됨() async {
        // given
        let polls = [PollItem.mockData(), PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getTrendingPollsResult = .success(polls)

        // when
        await sut.getTrendingPolls()

        // then
        XCTAssertEqual(sut.trendingPolls?.count, 3)
        XCTAssertFalse(sut.showErrorDialog)
    }

    func test_getTrendingPolls_이미데이터있으면_API_호출안함() async {
        // given
        mockUseCase.getTrendingPollsResult = .success([PollItem.mockData()])
        await sut.getTrendingPolls() // 첫 호출

        // when
        await sut.getTrendingPolls() // 두 번째 호출

        // then
        XCTAssertEqual(mockUseCase.getTrendingPollsCallCount, 1)
    }

    // MARK: - fetchPolls (pagination)

    func test_fetchPolls_성공시_기존목록에_추가됨() async {
        // given
        let firstItems = [PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getPollsResult = .success(.make(items: firstItems, totalCount: 4))
        await sut.getPolls()

        let nextItems = [PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getPollsResult = .success(.make(items: nextItems, totalCount: 4))

        // when
        await sut.fetchPolls()

        // then
        XCTAssertEqual(sut.allPolls?.items.count, 4)
    }

    func test_fetchPolls_끝이면_API_호출안함() async {
        // given
        let items = [PollItem.mockData()]
        mockUseCase.getPollsResult = .success(.make(items: items))
        await sut.getPolls()

        // isAllPollsEnd가 true가 되도록 빈 응답
        mockUseCase.getPollsResult = .success(.empty)
        await sut.fetchPolls()
        let countAfterEnd = mockUseCase.getPollsCallCount

        // when
        await sut.fetchPolls() // isAllPollsEnd == true이므로 호출 안 해야 함

        // then
        XCTAssertEqual(mockUseCase.getPollsCallCount, countAfterEnd)
    }

    // MARK: - handleError

    func test_handleError_호출시_errorMessage와_showErrorDialog_설정됨() {
        // when
        sut.handleError(error: .requestFailed("테스트 에러"))

        // then
        XCTAssertEqual(sut.errorMessage, "테스트 에러")
        XCTAssertTrue(sut.showErrorDialog)
    }
}
