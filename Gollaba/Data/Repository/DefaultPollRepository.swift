//
//  DefaultPollRepository.swift
//  Gollaba
//

import Foundation

class DefaultPollRepository: PollRepository {
    func fetchAllPolls(page: Int, size: Int) async throws -> AllPollData {
        return try await ApiManager.shared.getPolls(
            page: page, size: size,
            sort: .none, pollType: .none,
            optionGroup: .none, query: nil, isActive: .none
        ).get()
    }

    func fetchTrendingPolls() async throws -> [PollItem] {
        return try await ApiManager.shared.getTrendingPolls(limit: 10).get()
    }

    func fetchTopPolls() async throws -> [PollItem] {
        return try await ApiManager.shared.getTopPolls(limit: 10).get()
    }

    func fetchPollsCreatedByMe(page: Int, size: Int) async throws -> AllPollData {
        return try await ApiManager.shared.getPollsCreatedByMe(page: page, size: size).get()
    }

    func fetchPollsFavoriteByMe(page: Int, size: Int) async throws -> AllPollData {
        return try await ApiManager.shared.getPollsFavoriteByMe(page: page, size: size).get()
    }

    func fetchPollsParticipated(page: Int, size: Int) async throws -> AllPollData {
        return try await ApiManager.shared.getPollsParticipated(page: page, size: size).get()
    }

    func fetchPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async throws -> AllPollData {
        return try await ApiManager.shared.getPolls(
            page: page, size: size,
            sort: sort, pollType: pollType,
            optionGroup: optionGroup, query: query, isActive: isActive
        ).get()
    }

    func fetchTrendingSearchKeywords() async throws -> [TrendingSearchResponseData] {
        return try await ApiManager.shared.getTrendingSearchKeywords().get()
    }

    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async throws -> String {
        return try await ApiManager.shared.createPoll(
            title: title, creatorName: creatorName,
            responseType: responseType, pollType: pollType,
            endAt: endAt, items: items
        ).get()
    }
}
