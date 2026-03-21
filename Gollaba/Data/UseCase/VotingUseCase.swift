//
//  VotingUseCase.swift
//  Gollaba
//

import Foundation

protocol VotingUseCaseProtocol {
    func getPoll(pollHashId: String) async -> Result<PollItem, NetworkError>
    func readPoll(pollHashId: String) async -> Result<Void, NetworkError>
    func votingCheck(pollHashId: String) async -> Result<Bool, NetworkError>
    func getVotingId(pollHashId: String) async -> Result<VotingIdResponseData, NetworkError>
    func getVoters(pollHashId: String) async -> Result<[PollVotersResponseData], NetworkError>
    func vote(pollHashId: String, pollItemIds: [Int], voterName: String?) async -> Result<Void, NetworkError>
    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async -> Result<Void, NetworkError>
    func cancelVote(votingId: Int) async -> Result<Void, NetworkError>
    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async -> Result<Void, NetworkError>
}

class VotingUseCase: VotingUseCaseProtocol {
    private let votingRepository: VotingRepository

    init(votingRepository: VotingRepository = DefaultVotingRepository()) {
        self.votingRepository = votingRepository
    }

    func getPoll(pollHashId: String) async -> Result<PollItem, NetworkError> {
        do {
            let data = try await votingRepository.fetchPoll(pollHashId: pollHashId)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func readPoll(pollHashId: String) async -> Result<Void, NetworkError> {
        do {
            try await votingRepository.markPollRead(pollHashId: pollHashId)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func votingCheck(pollHashId: String) async -> Result<Bool, NetworkError> {
        do {
            let isVoted = try await votingRepository.checkVoting(pollHashId: pollHashId)
            return .success(isVoted)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getVotingId(pollHashId: String) async -> Result<VotingIdResponseData, NetworkError> {
        do {
            let data = try await votingRepository.fetchVotingId(pollHashId: pollHashId)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getVoters(pollHashId: String) async -> Result<[PollVotersResponseData], NetworkError> {
        do {
            let data = try await votingRepository.fetchVoters(pollHashId: pollHashId)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func vote(pollHashId: String, pollItemIds: [Int], voterName: String?) async -> Result<Void, NetworkError> {
        do {
            try await votingRepository.vote(pollHashId: pollHashId, pollItemIds: pollItemIds, voterName: voterName)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async -> Result<Void, NetworkError> {
        do {
            try await votingRepository.updateVote(votingId: votingId, voterName: voterName, pollItemIds: pollItemIds)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func cancelVote(votingId: Int) async -> Result<Void, NetworkError> {
        do {
            try await votingRepository.cancelVote(votingId: votingId)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async -> Result<Void, NetworkError> {
        do {
            try await votingRepository.reportPoll(pollHashId: pollHashId, content: content, reportType: reportType)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }
}
