@testable import Gollaba
import XCTest

@MainActor
final class PollDetailViewModelTests: XCTestCase {
    private var sut: PollDetailViewModel!
    private var mockVotingUseCase: MockVotingUseCase!
    private var mockFavoriteUseCase: MockFavoriteUseCase!

    override func setUp() {
        super.setUp()
        mockVotingUseCase = MockVotingUseCase()
        mockFavoriteUseCase = MockFavoriteUseCase()
        sut = PollDetailViewModel(
            id: "test-poll-id",
            votingUseCase: mockVotingUseCase,
            favoriteUseCase: mockFavoriteUseCase
        )
    }

    override func tearDown() {
        sut = nil
        mockVotingUseCase = nil
        mockFavoriteUseCase = nil
        super.tearDown()
    }

    // MARK: - showShareSheet 초기값

    func test_showShareSheet_초기값은_false() {
        XCTAssertFalse(sut.showShareSheet)
    }
}
