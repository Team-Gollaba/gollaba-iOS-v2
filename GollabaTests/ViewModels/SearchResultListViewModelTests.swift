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
