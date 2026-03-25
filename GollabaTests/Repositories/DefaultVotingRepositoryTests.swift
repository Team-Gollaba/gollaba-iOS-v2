@testable import Gollaba
import XCTest

final class DefaultVotingRepositoryTests: XCTestCase {
    private var sut: DefaultVotingRepository!
    private var mockApiManager: MockApiManager!

    override func setUp() {
        super.setUp()
        mockApiManager = MockApiManager()
        sut = DefaultVotingRepository(apiManager: mockApiManager)
    }

    override func tearDown() {
        sut = nil
        mockApiManager = nil
        super.tearDown()
    }

    // MARK: - fetchPoll

    func test_getPoll_성공시_PollItem_반환() async throws {
        // given
        let expectedPoll = PollItem.mockData()
        mockApiManager.getPollResult = .success(expectedPoll)

        // when
        let result = try await sut.fetchPoll(pollHashId: "test-hash")

        // then
        XCTAssertEqual(result.id, expectedPoll.id)
        XCTAssertEqual(result.title, expectedPoll.title)
    }

    func test_getPoll_실패시_에러_throw() async {
        // given
        mockApiManager.getPollResult = .failure(.requestFailed("투표 조회 실패"))

        // when / then
        do {
            _ = try await sut.fetchPoll(pollHashId: "test-hash")
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "투표 조회 실패")
        }
    }

    func test_getPoll_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.getPollResult = .success(.mockData())

        // when
        _ = try await sut.fetchPoll(pollHashId: "test-hash")

        // then
        XCTAssertEqual(mockApiManager.getPollCallCount, 1)
    }

    // MARK: - vote

    func test_voting_성공시_에러없음() async throws {
        // given
        mockApiManager.votingResult = .success(())

        // when / then (에러 없이 완료)
        try await sut.vote(pollHashId: "test-hash", pollItemIds: [1, 2], voterName: nil)
        XCTAssertEqual(mockApiManager.votingCallCount, 1)
    }

    func test_voting_실패시_에러_throw() async {
        // given
        mockApiManager.votingResult = .failure(.requestFailed("투표 실패"))

        // when / then
        do {
            try await sut.vote(pollHashId: "test-hash", pollItemIds: [1], voterName: nil)
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "투표 실패")
        }
    }

    func test_voting_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.votingResult = .success(())

        // when
        try await sut.vote(pollHashId: "test-hash", pollItemIds: [1], voterName: nil)

        // then
        XCTAssertEqual(mockApiManager.votingCallCount, 1)
    }

    // MARK: - checkVoting

    func test_votingCheck_성공시_Bool_반환() async throws {
        // given
        mockApiManager.votingCheckResult = .success(true)

        // when
        let result = try await sut.checkVoting(pollHashId: "test-hash")

        // then
        XCTAssertTrue(result)
    }

    func test_votingCheck_false_반환() async throws {
        // given
        mockApiManager.votingCheckResult = .success(false)

        // when
        let result = try await sut.checkVoting(pollHashId: "test-hash")

        // then
        XCTAssertFalse(result)
    }

    func test_votingCheck_실패시_에러_throw() async {
        // given
        mockApiManager.votingCheckResult = .failure(.requestFailed("투표 확인 실패"))

        // when / then
        do {
            _ = try await sut.checkVoting(pollHashId: "test-hash")
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "투표 확인 실패")
        }
    }

    func test_votingCheck_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.votingCheckResult = .success(false)

        // when
        _ = try await sut.checkVoting(pollHashId: "test-hash")

        // then
        XCTAssertEqual(mockApiManager.votingCheckCallCount, 1)
    }
}
