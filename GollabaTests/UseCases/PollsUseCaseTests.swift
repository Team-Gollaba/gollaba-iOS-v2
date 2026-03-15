@testable import Gollaba
import XCTest

final class PollsUseCaseTests: XCTestCase {
    private var sut: PollsUseCase!
    private var mockRepository: MockPollRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockPollRepository()
        sut = PollsUseCase(pollRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - getPolls

    func test_getPolls_성공시_AllPollData_반환() async {
        // given
        let expectedItems = [PollItem.mockData(), PollItem.mockData()]
        let expectedData = AllPollData.make(items: expectedItems)
        mockRepository.fetchAllPollsResult = .success(expectedData)

        // when
        let result = await sut.getPolls(page: 0, size: 10)

        // then
        if case .success(let data) = result {
            XCTAssertEqual(data.items.count, 2)
            XCTAssertEqual(data.totalCount, 2)
        } else {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }

    func test_getPolls_실패시_NetworkError_반환() async {
        // given
        mockRepository.fetchAllPollsResult = .failure(NetworkError.requestFailed("서버 오류"))

        // when
        let result = await sut.getPolls(page: 0, size: 10)

        // then
        if case .failure(let error) = result {
            XCTAssertEqual(error.description, "서버 오류")
        } else {
            XCTFail("실패 결과를 기대했으나 성공")
        }
    }

    // MARK: - getTrendingPolls

    func test_getTrendingPolls_성공시_PollItem_배열_반환() async {
        // given
        let expectedPolls = [PollItem.mockData(), PollItem.mockData(), PollItem.mockData()]
        mockRepository.fetchTrendingPollsResult = .success(expectedPolls)

        // when
        let result = await sut.getTrendingPolls()

        // then
        if case .success(let polls) = result {
            XCTAssertEqual(polls.count, 3)
        } else {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }

    func test_getTrendingPolls_실패시_NetworkError_반환() async {
        // given
        mockRepository.fetchTrendingPollsResult = .failure(NetworkError.notFoundToken)

        // when
        let result = await sut.getTrendingPolls()

        // then
        if case .failure(let error) = result {
            XCTAssertEqual(error.description, NetworkError.notFoundToken.description)
        } else {
            XCTFail("실패 결과를 기대했으나 성공")
        }
    }

    // MARK: - createPoll

    func test_createPoll_성공시_hashId_반환() async {
        // given
        let expectedHashId = "abc-123"
        mockRepository.createPollResult = .success(expectedHashId)

        // when
        let result = await sut.createPoll(
            title: "테스트 투표",
            creatorName: "작성자",
            responseType: "SINGLE",
            pollType: "ANONYMOUS",
            endAt: Date(),
            items: []
        )

        // then
        if case .success(let hashId) = result {
            XCTAssertEqual(hashId, expectedHashId)
        } else {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }

    // MARK: - getPollsCreatedByMe

    func test_getPollsCreatedByMe_성공시_데이터_반환() async {
        // given
        let items = [PollItem.mockData()]
        mockRepository.fetchPollsCreatedByMeResult = .success(.make(items: items))

        // when
        let result = await sut.getPollsCreatedByMe(page: 0, size: 10)

        // then
        if case .success(let data) = result {
            XCTAssertEqual(data.items.count, 1)
        } else {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }
}
