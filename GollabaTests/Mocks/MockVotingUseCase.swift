@testable import Gollaba
import Foundation

final class MockVotingUseCase: VotingUseCaseProtocol {
    // MARK: - Stubs
    var getPollResult: Result<PollItem, NetworkError> = .success(.mockData())
    var readPollResult: Result<Void, NetworkError> = .success(())
    var votingCheckResult: Result<Bool, NetworkError> = .success(false)
    var getVotingIdResult: Result<VotingIdResponseData, NetworkError> = .success(.mock)
    var getVotersResult: Result<[PollVotersResponseData], NetworkError> = .success([])
    var voteResult: Result<Void, NetworkError> = .success(())
    var updateVoteResult: Result<Void, NetworkError> = .success(())
    var cancelVoteResult: Result<Void, NetworkError> = .success(())
    var reportPollResult: Result<Void, NetworkError> = .success(())

    // MARK: - Call counts
    var getPollCallCount = 0

    func getPoll(pollHashId: String) async -> Result<PollItem, NetworkError> {
        getPollCallCount += 1
        return getPollResult
    }

    func readPoll(pollHashId: String) async -> Result<Void, NetworkError> {
        return readPollResult
    }

    func votingCheck(pollHashId: String) async -> Result<Bool, NetworkError> {
        return votingCheckResult
    }

    func getVotingId(pollHashId: String) async -> Result<VotingIdResponseData, NetworkError> {
        return getVotingIdResult
    }

    func getVoters(pollHashId: String) async -> Result<[PollVotersResponseData], NetworkError> {
        return getVotersResult
    }

    func vote(pollHashId: String, pollItemIds: [Int], voterName: String?) async -> Result<Void, NetworkError> {
        return voteResult
    }

    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async -> Result<Void, NetworkError> {
        return updateVoteResult
    }

    func cancelVote(votingId: Int) async -> Result<Void, NetworkError> {
        return cancelVoteResult
    }

    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async -> Result<Void, NetworkError> {
        return reportPollResult
    }
}

// MARK: - VotingIdResponseData helper
extension VotingIdResponseData {
    static var mock: VotingIdResponseData {
        VotingIdResponseData(votingId: 1, votedItemIds: [])
    }
}
