//
//  VotingRepository.swift
//  Gollaba
//

import Foundation

protocol VotingRepositoryProtocol {
    func fetchPoll(pollHashId: String) async throws -> PollItem
    func markPollRead(pollHashId: String) async throws
    func checkVoting(pollHashId: String) async throws -> Bool
    func fetchVotingId(pollHashId: String) async throws -> VotingIdResponseData
    func fetchVoters(pollHashId: String) async throws -> [PollVotersResponseData]
    func vote(pollHashId: String, pollItemIds: [Int], voterName: String?) async throws
    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async throws
    func cancelVote(votingId: Int) async throws
    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async throws
}

class VotingRepositoryImpl: VotingRepositoryProtocol {
    func fetchPoll(pollHashId: String) async throws -> PollItem {
        return try await ApiManager.shared.getPoll(pollHashId: pollHashId).get()
    }

    func markPollRead(pollHashId: String) async throws {
        try await ApiManager.shared.readPoll(pollHashId: pollHashId).get()
    }

    func checkVoting(pollHashId: String) async throws -> Bool {
        return try await ApiManager.shared.votingCheck(pollHashId: pollHashId).get()
    }

    func fetchVotingId(pollHashId: String) async throws -> VotingIdResponseData {
        return try await ApiManager.shared.getVotingIdByPollHashId(pollHashId: pollHashId).get()
    }

    func fetchVoters(pollHashId: String) async throws -> [PollVotersResponseData] {
        return try await ApiManager.shared.getVoters(pollHashId: pollHashId).get()
    }

    func vote(pollHashId: String, pollItemIds: [Int], voterName: String?) async throws {
        try await ApiManager.shared.voting(pollHashId: pollHashId, pollItemIds: pollItemIds, voterName: voterName).get()
    }

    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async throws {
        try await ApiManager.shared.updateVote(votingId: votingId, voterName: voterName, pollItemIds: pollItemIds).get()
    }

    func cancelVote(votingId: Int) async throws {
        try await ApiManager.shared.cancelVote(votingId: votingId).get()
    }

    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async throws {
        try await ApiManager.shared.reportPoll(pollHashId: pollHashId, content: content, reportType: reportType).get()
    }
}
