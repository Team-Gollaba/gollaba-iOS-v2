@testable import Gollaba
import XCTest

@MainActor
final class SearchViewModelTests: XCTestCase {
    private var sut: SearchViewModel!
    private var mockUseCase: MockPollsUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockPollsUseCase()
        sut = SearchViewModel(pollsUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // MARK: - getTrendingKeywords

    func test_getTrendingKeywords_성공시_trendingKeywords_설정됨() async {
        // given
        let keywords = [
            TrendingSearchResponseData(searchedWord: "고양이", searchCount: 10),
            TrendingSearchResponseData(searchedWord: "강아지", searchCount: 8)
        ]
        mockUseCase.getTrendingSearchKeywordsResult = .success(keywords)

        // when
        await sut.getTrendingKeywords()

        // then
        XCTAssertEqual(sut.trendingKeywords.count, 2)
        XCTAssertNotNil(sut.whenGetToRecommendedKeywords)
        XCTAssertFalse(sut.showErrorDialog)
    }

    func test_getTrendingKeywords_실패시_showErrorDialog_true() async {
        // given
        mockUseCase.getTrendingSearchKeywordsResult = .failure(.requestFailed("키워드 로드 실패"))

        // when
        await sut.getTrendingKeywords()

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "키워드 로드 실패")
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
