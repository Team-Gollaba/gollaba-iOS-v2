//
//  DefaultVotingRepository.swift
//  Gollaba
//

import Foundation

class DefaultVotingRepository: VotingRepository {
    private let apiManager: any ApiManagerProtocol

    init(apiManager: any ApiManagerProtocol = ApiManager.shared) {
        self.apiManager = apiManager
    }

    func fetchPoll(pollHashId: String) async throws -> PollItem {
        return try await apiManager.getPoll(pollHashId: pollHashId).get()
    }

    func markPollRead(pollHashId: String) async throws {
        try await apiManager.readPoll(pollHashId: pollHashId).get()
    }

    func checkVoting(pollHashId: String) async throws -> Bool {
        return try await apiManager.votingCheck(pollHashId: pollHashId).get()
    }

    func fetchVotingId(pollHashId: String) async throws -> VotingIdResponseData {
        return try await apiManager.getVotingIdByPollHashId(pollHashId: pollHashId).get()
    }

    func fetchVoters(pollHashId: String) async throws -> [PollVotersResponseData] {
        return try await apiManager.getVoters(pollHashId: pollHashId).get()
    }

    func vote(pollHashId: String, pollItemIds: [Int], voterName: String?) async throws {
        try await apiManager.voting(pollHashId: pollHashId, pollItemIds: pollItemIds, voterName: voterName).get()
    }

    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async throws {
        try await apiManager.updateVote(votingId: votingId, voterName: voterName, pollItemIds: pollItemIds).get()
    }

    func cancelVote(votingId: Int) async throws {
        try await apiManager.cancelVote(votingId: votingId).get()
    }

    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async throws {
        try await apiManager.reportPoll(pollHashId: pollHashId, content: content, reportType: reportType).get()
    }
}
