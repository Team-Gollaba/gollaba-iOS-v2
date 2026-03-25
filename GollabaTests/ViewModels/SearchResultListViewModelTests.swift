@testable import Gollaba
import XCTest

@MainActor
final class SearchResultListViewModelTests: XCTestCase {
    private var sut: SearchResultListViewModel!
    private var mockUseCase: MockPollsUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockPollsUseCase()
        sut = SearchResultListViewModel(query: "테스트", pollsUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // MARK: - getSearchResultByFilter

    func test_getSearchResultByFilter_성공시_결과_설정됨() async {
        // given
        let items = [PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getFilteredPollsResult = .success(.make(items: items))

        // when
        await sut.getSearchResultByFilter()

        // then
        XCTAssertEqual(sut.searchResultPollData?.items.count, 2)
        XCTAssertFalse(sut.showErrorDialog)
        XCTAssertFalse(sut.isLoading)
    }

    func test_getSearchResultByFilter_실패시_showErrorDialog_true() async {
        // given
        mockUseCase.getFilteredPollsResult = .failure(.requestFailed("검색 실패"))

        // when
        await sut.getSearchResultByFilter()

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "검색 실패")
        XCTAssertFalse(sut.isLoading)
    }

    func test_getSearchResultByFilter_searchText_반영됨() async {
        // given
        mockUseCase.getFilteredPollsResult = .success(.empty)
        sut.searchText = "새 검색어"

        // when
        await sut.getSearchResultByFilter()

        // then
        XCTAssertEqual(sut.searchText, "새 검색어")
    }

    // MARK: - fetchMoreResultByFilter

    func test_fetchMoreResultByFilter_isEnd이면_데이터_변경없음() async {
        // given - 1건 로드 (items.count == totalCount → isEnd = true)
        let items = [PollItem.mockData()]
        mockUseCase.getFilteredPollsResult = .success(.make(items: items))
        await sut.getSearchResultByFilter()
        XCTAssertTrue(sut.isEnd)

        mockUseCase.getFilteredPollsResult = .success(.empty)

        // when
        await sut.fetchMoreResultByFilter()

        // then
        XCTAssertEqual(sut.searchResultPollData?.items.count, 1)
        XCTAssertTrue(sut.isEnd)
    }

    func test_fetchMoreResultByFilter_결과_기존목록에_추가됨() async {
        // given - 첫 로드 2건, totalCount=4 (isEnd = false)
        let firstItems = [PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getFilteredPollsResult = .success(.make(items: firstItems, totalCount: 4))
        await sut.getSearchResultByFilter()
        XCTAssertFalse(sut.isEnd)

        let secondItems = [PollItem.mockData(), PollItem.mockData()]
        mockUseCase.getFilteredPollsResult = .success(.make(items: secondItems))

        // when
        await sut.fetchMoreResultByFilter()

        // then
        XCTAssertEqual(sut.searchResultPollData?.items.count, 4)
    }

    // MARK: - debounce 자동 검색

    func test_searchText_변경시_debounce후_자동검색_호출됨() async {
        // given
        mockUseCase.getFilteredPollsResult = .success(.empty)
        let beforeCount = mockUseCase.getFilteredPollsCallCount

        // when
        sut.searchText = "새검색어"
        try? await Task.sleep(nanoseconds: 600_000_000)

        // then
        XCTAssertGreaterThan(mockUseCase.getFilteredPollsCallCount, beforeCount)
    }

    func test_searchText_빠르게_변경시_debounce로_한번만_호출됨() async {
        // given
        mockUseCase.getFilteredPollsResult = .success(.empty)
        let beforeCount = mockUseCase.getFilteredPollsCallCount

        // when - 0.1초 간격으로 여러 번 변경
        sut.searchText = "첫번째"
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.searchText = "두번째"
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.searchText = "세번째"
        try? await Task.sleep(nanoseconds: 800_000_000)

        // then - debounce로 인해 1회만 호출됨
        XCTAssertEqual(mockUseCase.getFilteredPollsCallCount, beforeCount + 1)
    }

    func test_searchText_빈문자열이면_자동검색_호출안됨() async {
        // given
        mockUseCase.getFilteredPollsResult = .success(.empty)
        let beforeCount = mockUseCase.getFilteredPollsCallCount

        // when
        sut.searchText = ""
        try? await Task.sleep(nanoseconds: 600_000_000)

        // then - filter { !$0.isEmpty } 로 인해 호출되지 않음
        XCTAssertEqual(mockUseCase.getFilteredPollsCallCount, beforeCount)
    }

    // MARK: - isValidSearchText

    func test_isValidSearchText_빈문자열이면_false_및_toast_표시() {
        // given
        sut.searchText = ""

        // when
        let result = sut.isValidSearchText()

        // then
        XCTAssertFalse(result)
        XCTAssertTrue(sut.showKeywordEmptyErrorToast)
    }

    func test_isValidSearchText_텍스트있으면_true() {
        // given
        sut.searchText = "고양이"

        // when
        let result = sut.isValidSearchText()

        // then
        XCTAssertTrue(result)
        XCTAssertFalse(sut.showKeywordEmptyErrorToast)
    }
}
