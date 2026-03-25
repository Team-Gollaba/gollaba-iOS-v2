@testable import Gollaba
import XCTest

final class DefaultPollRepositoryTests: XCTestCase {
    private var sut: DefaultPollRepository!
    private var mockApiManager: MockApiManager!

    override func setUp() {
        super.setUp()
        mockApiManager = MockApiManager()
        sut = DefaultPollRepository(apiManager: mockApiManager)
    }

    override func tearDown() {
        sut = nil
        mockApiManager = nil
        super.tearDown()
    }

    // MARK: - fetchAllPolls

    func test_fetchAllPolls_성공시_AllPollData_반환() async throws {
        // given
        let expectedItems = [PollItem.mockData(), PollItem.mockData()]
        let expectedData = AllPollData.make(items: expectedItems)
        mockApiManager.getPollsResult = .success(expectedData)

        // when
        let result = try await sut.fetchAllPolls(page: 0, size: 10)

        // then
        XCTAssertEqual(result.items.count, 2)
        XCTAssertEqual(result.totalCount, 2)
    }

    func test_fetchAllPolls_실패시_에러_throw() async {
        // given
        mockApiManager.getPollsResult = .failure(.requestFailed("서버 오류"))

        // when / then
        do {
            _ = try await sut.fetchAllPolls(page: 0, size: 10)
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "서버 오류")
        }
    }

    func test_fetchAllPolls_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.getPollsResult = .success(.empty)

        // when
        _ = try await sut.fetchAllPolls(page: 0, size: 10)

        // then
        XCTAssertEqual(mockApiManager.getPollsCallCount, 1)
    }

    // MARK: - fetchTrendingPolls

    func test_fetchTrendingPolls_성공시_PollItem배열_반환() async throws {
        // given
        let expectedPolls = [PollItem.mockData(), PollItem.mockData(), PollItem.mockData()]
        mockApiManager.getTrendingPollsResult = .success(expectedPolls)

        // when
        let result = try await sut.fetchTrendingPolls()

        // then
        XCTAssertEqual(result.count, 3)
    }

    func test_fetchTrendingPolls_실패시_에러_throw() async {
        // given
        mockApiManager.getTrendingPollsResult = .failure(.notFoundToken)

        // when / then
        do {
            _ = try await sut.fetchTrendingPolls()
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, NetworkError.notFoundToken.description)
        }
    }

    func test_fetchTrendingPolls_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.getTrendingPollsResult = .success([])

        // when
        _ = try await sut.fetchTrendingPolls()

        // then
        XCTAssertEqual(mockApiManager.getTrendingPollsCallCount, 1)
    }

    // MARK: - createPoll

    func test_createPoll_성공시_pollHashId_반환() async throws {
        // given
        let expectedHashId = "abc-123"
        mockApiManager.createPollResult = .success(expectedHashId)

        // when
        let result = try await sut.createPoll(
            title: "테스트 투표",
            creatorName: "작성자",
            responseType: "SINGLE",
            pollType: "ANONYMOUS",
            endAt: Date(),
            items: []
        )

        // then
        XCTAssertEqual(result, expectedHashId)
    }

    func test_createPoll_실패시_에러_throw() async {
        // given
        mockApiManager.createPollResult = .failure(.requestFailed("생성 실패"))

        // when / then
        do {
            _ = try await sut.createPoll(
                title: "테스트 투표",
                creatorName: "작성자",
                responseType: "SINGLE",
                pollType: "ANONYMOUS",
                endAt: Date(),
                items: []
            )
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "생성 실패")
        }
    }

    func test_createPoll_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.createPollResult = .success("hash")

        // when
        _ = try await sut.createPoll(
            title: "투표",
            creatorName: "작성자",
            responseType: "SINGLE",
            pollType: "ANONYMOUS",
            endAt: Date(),
            items: []
        )

        // then
        XCTAssertEqual(mockApiManager.createPollCallCount, 1)
    }
}
