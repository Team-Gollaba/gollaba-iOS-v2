@testable import Gollaba
import Foundation

final class MockPollRepository: PollRepository {
    var fetchAllPollsResult: Result<AllPollData, Error> = .success(.empty)
    var fetchTrendingPollsResult: Result<[PollItem], Error> = .success([])
    var fetchTopPollsResult: Result<[PollItem], Error> = .success([])
    var fetchPollsCreatedByMeResult: Result<AllPollData, Error> = .success(.empty)
    var fetchPollsFavoriteByMeResult: Result<AllPollData, Error> = .success(.empty)
    var fetchPollsParticipatedResult: Result<AllPollData, Error> = .success(.empty)
    var fetchFilteredPollsResult: Result<AllPollData, Error> = .success(.empty)
    var fetchTrendingSearchKeywordsResult: Result<[TrendingSearchResponseData], Error> = .success([])
    var createPollResult: Result<String, Error> = .success("hash-id")

    func fetchAllPolls(page: Int, size: Int) async throws -> AllPollData {
        return try fetchAllPollsResult.get()
    }

    func fetchTrendingPolls() async throws -> [PollItem] {
        return try fetchTrendingPollsResult.get()
    }

    func fetchTopPolls() async throws -> [PollItem] {
        return try fetchTopPollsResult.get()
    }

    func fetchPollsCreatedByMe(page: Int, size: Int) async throws -> AllPollData {
        return try fetchPollsCreatedByMeResult.get()
    }

    func fetchPollsFavoriteByMe(page: Int, size: Int) async throws -> AllPollData {
        return try fetchPollsFavoriteByMeResult.get()
    }

    func fetchPollsParticipated(page: Int, size: Int) async throws -> AllPollData {
        return try fetchPollsParticipatedResult.get()
    }

    func fetchPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async throws -> AllPollData {
        return try fetchFilteredPollsResult.get()
    }

    func fetchTrendingSearchKeywords() async throws -> [TrendingSearchResponseData] {
        return try fetchTrendingSearchKeywordsResult.get()
    }

    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async throws -> String {
        return try createPollResult.get()
    }
}
