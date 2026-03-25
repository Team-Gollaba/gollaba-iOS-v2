@testable import Gollaba
import SwiftUI

final class MockApiManager: ApiManagerProtocol {
    // MARK: - getPolls
    var getPollsResult: Result<AllPollData, NetworkError> = .failure(.requestFailed("mock"))
    var getPollsCallCount = 0

    func getPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async -> Result<AllPollData, NetworkError> {
        getPollsCallCount += 1
        return getPollsResult
    }

    // MARK: - getTrendingPolls
    var getTrendingPollsResult: Result<[PollItem], NetworkError> = .failure(.requestFailed("mock"))
    var getTrendingPollsCallCount = 0

    func getTrendingPolls(limit: Int) async -> Result<[PollItem], NetworkError> {
        getTrendingPollsCallCount += 1
        return getTrendingPollsResult
    }

    // MARK: - getTopPolls
    var getTopPollsResult: Result<[PollItem], NetworkError> = .failure(.requestFailed("mock"))
    var getTopPollsCallCount = 0

    func getTopPolls(limit: Int) async -> Result<[PollItem], NetworkError> {
        getTopPollsCallCount += 1
        return getTopPollsResult
    }

    // MARK: - getPollsCreatedByMe
    var getPollsCreatedByMeResult: Result<AllPollData, NetworkError> = .failure(.requestFailed("mock"))
    var getPollsCreatedByMeCallCount = 0

    func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        getPollsCreatedByMeCallCount += 1
        return getPollsCreatedByMeResult
    }

    // MARK: - getPollsFavoriteByMe
    var getPollsFavoriteByMeResult: Result<AllPollData, NetworkError> = .failure(.requestFailed("mock"))
    var getPollsFavoriteByMeCallCount = 0

    func getPollsFavoriteByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        getPollsFavoriteByMeCallCount += 1
        return getPollsFavoriteByMeResult
    }

    // MARK: - getPollsParticipated
    var getPollsParticipatedResult: Result<AllPollData, NetworkError> = .failure(.requestFailed("mock"))
    var getPollsParticipatedCallCount = 0

    func getPollsParticipated(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        getPollsParticipatedCallCount += 1
        return getPollsParticipatedResult
    }

    // MARK: - getTrendingSearchKeywords
    var getTrendingSearchKeywordsResult: Result<[TrendingSearchResponseData], NetworkError> = .failure(.requestFailed("mock"))
    var getTrendingSearchKeywordsCallCount = 0

    func getTrendingSearchKeywords() async -> Result<[TrendingSearchResponseData], NetworkError> {
        getTrendingSearchKeywordsCallCount += 1
        return getTrendingSearchKeywordsResult
    }

    // MARK: - createPoll
    var createPollResult: Result<String, NetworkError> = .failure(.requestFailed("mock"))
    var createPollCallCount = 0

    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async -> Result<String, NetworkError> {
        createPollCallCount += 1
        return createPollResult
    }

    // MARK: - getUserMe
    var getUserMeResult: Result<UserData, NetworkError> = .failure(.requestFailed("mock"))
    var getUserMeCallCount = 0

    func getUserMe() async -> Result<UserData, NetworkError> {
        getUserMeCallCount += 1
        return getUserMeResult
    }

    // MARK: - updateUserName
    var updateUserNameResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var updateUserNameCallCount = 0

    func updateUserName(name: String) async -> Result<Void, NetworkError> {
        updateUserNameCallCount += 1
        return updateUserNameResult
    }

    // MARK: - updateUserProfileImage
    var updateUserProfileImageResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var updateUserProfileImageCallCount = 0

    func updateUserProfileImage(image: UIImage) async -> Result<Void, NetworkError> {
        updateUserProfileImageCallCount += 1
        return updateUserProfileImageResult
    }

    // MARK: - deleteUserProfileImage
    var deleteUserProfileImageResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var deleteUserProfileImageCallCount = 0

    func deleteUserProfileImage() async -> Result<Void, NetworkError> {
        deleteUserProfileImageCallCount += 1
        return deleteUserProfileImageResult
    }

    // MARK: - deleteAccount
    var deleteAccountResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var deleteAccountCallCount = 0

    func deleteAccount() async -> Result<Void, NetworkError> {
        deleteAccountCallCount += 1
        return deleteAccountResult
    }

    // MARK: - loginByProviderToken
    var loginByProviderTokenResult: Result<String, NetworkError> = .failure(.requestFailed("mock"))
    var loginByProviderTokenCallCount = 0

    func loginByProviderToken(providerToken: String, providerType: ProviderType) async -> Result<String, NetworkError> {
        loginByProviderTokenCallCount += 1
        return loginByProviderTokenResult
    }

    // MARK: - signUp
    var signUpResult: Result<String, NetworkError> = .failure(.requestFailed("mock"))
    var signUpCallCount = 0

    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async -> Result<String, NetworkError> {
        signUpCallCount += 1
        return signUpResult
    }

    // MARK: - uploadImage
    var uploadImageResult: Result<[String], NetworkError> = .failure(.requestFailed("mock"))
    var uploadImageCallCount = 0

    func uploadImage(images: [UIImage]) async -> Result<[String], NetworkError> {
        uploadImageCallCount += 1
        return uploadImageResult
    }

    // MARK: - createFavoritePoll
    var createFavoritePollResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var createFavoritePollCallCount = 0

    func createFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        createFavoritePollCallCount += 1
        return createFavoritePollResult
    }

    // MARK: - deleteFavoritePoll
    var deleteFavoritePollResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var deleteFavoritePollCallCount = 0

    func deleteFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        deleteFavoritePollCallCount += 1
        return deleteFavoritePollResult
    }

    // MARK: - getFavoritePolls
    var getFavoritePollsResult: Result<[String], NetworkError> = .failure(.requestFailed("mock"))
    var getFavoritePollsCallCount = 0

    func getFavoritePolls() async -> Result<[String], NetworkError> {
        getFavoritePollsCallCount += 1
        return getFavoritePollsResult
    }

    // MARK: - getPoll
    var getPollResult: Result<PollItem, NetworkError> = .failure(.requestFailed("mock"))
    var getPollCallCount = 0

    func getPoll(pollHashId: String) async -> Result<PollItem, NetworkError> {
        getPollCallCount += 1
        return getPollResult
    }

    // MARK: - readPoll
    var readPollResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var readPollCallCount = 0

    func readPoll(pollHashId: String) async -> Result<Void, NetworkError> {
        readPollCallCount += 1
        return readPollResult
    }

    // MARK: - votingCheck
    var votingCheckResult: Result<Bool, NetworkError> = .failure(.requestFailed("mock"))
    var votingCheckCallCount = 0

    func votingCheck(pollHashId: String) async -> Result<Bool, NetworkError> {
        votingCheckCallCount += 1
        return votingCheckResult
    }

    // MARK: - getVotingIdByPollHashId
    var getVotingIdByPollHashIdResult: Result<VotingIdResponseData, NetworkError> = .failure(.requestFailed("mock"))
    var getVotingIdByPollHashIdCallCount = 0

    func getVotingIdByPollHashId(pollHashId: String) async -> Result<VotingIdResponseData, NetworkError> {
        getVotingIdByPollHashIdCallCount += 1
        return getVotingIdByPollHashIdResult
    }

    // MARK: - getVoters
    var getVotersResult: Result<[PollVotersResponseData], NetworkError> = .failure(.requestFailed("mock"))
    var getVotersCallCount = 0

    func getVoters(pollHashId: String) async -> Result<[PollVotersResponseData], NetworkError> {
        getVotersCallCount += 1
        return getVotersResult
    }

    // MARK: - voting
    var votingResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var votingCallCount = 0

    func voting(pollHashId: String, pollItemIds: [Int], voterName: String?) async -> Result<Void, NetworkError> {
        votingCallCount += 1
        return votingResult
    }

    // MARK: - updateVote
    var updateVoteResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var updateVoteCallCount = 0

    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async -> Result<Void, NetworkError> {
        updateVoteCallCount += 1
        return updateVoteResult
    }

    // MARK: - cancelVote
    var cancelVoteResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var cancelVoteCallCount = 0

    func cancelVote(votingId: Int) async -> Result<Void, NetworkError> {
        cancelVoteCallCount += 1
        return cancelVoteResult
    }

    // MARK: - reportPoll
    var reportPollResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var reportPollCallCount = 0

    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async -> Result<Void, NetworkError> {
        reportPollCallCount += 1
        return reportPollResult
    }

    // MARK: - getPushNotificationHistory
    var getPushNotificationHistoryResult: Result<PushNotificationDatas, NetworkError> = .failure(.requestFailed("mock"))
    var getPushNotificationHistoryCallCount = 0

    func getPushNotificationHistory(page: Int, size: Int) async -> Result<PushNotificationDatas, NetworkError> {
        getPushNotificationHistoryCallCount += 1
        return getPushNotificationHistoryResult
    }

    // MARK: - createAppPushNotification
    var createAppPushNotificationResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var createAppPushNotificationCallCount = 0

    func createAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        createAppPushNotificationCallCount += 1
        return createAppPushNotificationResult
    }

    // MARK: - updateAppPushNotification
    var updateAppPushNotificationResult: Result<Void, NetworkError> = .failure(.requestFailed("mock"))
    var updateAppPushNotificationCallCount = 0

    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        updateAppPushNotificationCallCount += 1
        return updateAppPushNotificationResult
    }
}
