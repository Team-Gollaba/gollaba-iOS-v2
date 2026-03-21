//
//  VotingRepository.swift
//  Gollaba
//

import Foundation

protocol VotingRepository {
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
