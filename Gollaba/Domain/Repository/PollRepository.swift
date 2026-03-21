//
//  PollRepository.swift
//  Gollaba
//

import Foundation

protocol PollRepository {
    func fetchAllPolls(page: Int, size: Int) async throws -> AllPollData
    func fetchTrendingPolls() async throws -> [PollItem]
    func fetchTopPolls() async throws -> [PollItem]
    func fetchPollsCreatedByMe(page: Int, size: Int) async throws -> AllPollData
    func fetchPollsFavoriteByMe(page: Int, size: Int) async throws -> AllPollData
    func fetchPollsParticipated(page: Int, size: Int) async throws -> AllPollData
    func fetchPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async throws -> AllPollData
    func fetchTrendingSearchKeywords() async throws -> [TrendingSearchResponseData]
    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async throws -> String
}
