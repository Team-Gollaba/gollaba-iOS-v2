@testable import Gollaba
import Foundation

final class MockPollsUseCase: PollsUseCaseProtocol {
    // MARK: - Stubs
    var getPollsResult: Result<AllPollData, NetworkError> = .success(.empty)
    var getTrendingPollsResult: Result<[PollItem], NetworkError> = .success([])
    var getTopPollsResult: Result<[PollItem], NetworkError> = .success([])
    var getPollsCreatedByMeResult: Result<AllPollData, NetworkError> = .success(.empty)
    var getPollsFavoriteByMeResult: Result<AllPollData, NetworkError> = .success(.empty)
    var getPollsParticipatedResult: Result<AllPollData, NetworkError> = .success(.empty)
    var getFilteredPollsResult: Result<AllPollData, NetworkError> = .success(.empty)
    var getTrendingSearchKeywordsResult: Result<[TrendingSearchResponseData], NetworkError> = .success([])
    var createPollResult: Result<String, NetworkError> = .success("")

    // MARK: - Call counts
    var getPollsCallCount = 0
    var getTrendingPollsCallCount = 0
    var getTopPollsCallCount = 0
    var getFilteredPollsCallCount = 0

    func getPolls(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        getPollsCallCount += 1
        return getPollsResult
    }

    func getTrendingPolls() async -> Result<[PollItem], NetworkError> {
        getTrendingPollsCallCount += 1
        return getTrendingPollsResult
    }

    func getTopPolls() async -> Result<[PollItem], NetworkError> {
        getTopPollsCallCount += 1
        return getTopPollsResult
    }

    func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        return getPollsCreatedByMeResult
    }

    func getPollsFavoriteByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        return getPollsFavoriteByMeResult
    }

    func getPollsParticipated(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        return getPollsParticipatedResult
    }

    func getPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async -> Result<AllPollData, NetworkError> {
        getFilteredPollsCallCount += 1
        return getFilteredPollsResult
    }

    func getTrendingSearchKeywords() async -> Result<[TrendingSearchResponseData], NetworkError> {
        return getTrendingSearchKeywordsResult
    }

    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async -> Result<String, NetworkError> {
        return createPollResult
    }
}

// MARK: - AllPollData helper
extension AllPollData {
    static var empty: AllPollData {
        AllPollData(items: [], page: 0, size: 10, totalCount: 0, totalPage: 0, empty: true)
    }

    static func make(items: [PollItem], totalCount: Int? = nil) -> AllPollData {
        AllPollData(items: items, page: 0, size: 10, totalCount: totalCount ?? items.count, totalPage: 1, empty: items.isEmpty)
    }
}
