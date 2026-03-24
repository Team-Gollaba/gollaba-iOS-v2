//
//  ApiManagerProtocol.swift
//  Gollaba
//

import SwiftUI

protocol ApiManagerProtocol: AnyObject, Sendable {
    func getPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async -> Result<AllPollData, NetworkError>
    func getTrendingPolls(limit: Int) async -> Result<[PollItem], NetworkError>
    func getTopPolls(limit: Int) async -> Result<[PollItem], NetworkError>
    func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getPollsFavoriteByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getPollsParticipated(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getTrendingSearchKeywords() async -> Result<[TrendingSearchResponseData], NetworkError>
    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async -> Result<String, NetworkError>
    func getUserMe() async -> Result<UserData, NetworkError>
    func updateUserName(name: String) async -> Result<Void, NetworkError>
    func updateUserProfileImage(image: UIImage) async -> Result<Void, NetworkError>
    func deleteUserProfileImage() async -> Result<Void, NetworkError>
    func deleteAccount() async -> Result<Void, NetworkError>
    func loginByProviderToken(providerToken: String, providerType: ProviderType) async -> Result<String, NetworkError>
    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async -> Result<String, NetworkError>
    func uploadImage(images: [UIImage]) async -> Result<[String], NetworkError>
    func createFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError>
    func deleteFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError>
    func getFavoritePolls() async -> Result<[String], NetworkError>
    func getPoll(pollHashId: String) async -> Result<PollItem, NetworkError>
    func readPoll(pollHashId: String) async -> Result<Void, NetworkError>
    func votingCheck(pollHashId: String) async -> Result<Bool, NetworkError>
    func getVotingIdByPollHashId(pollHashId: String) async -> Result<VotingIdResponseData, NetworkError>
    func getVoters(pollHashId: String) async -> Result<[PollVotersResponseData], NetworkError>
    func voting(pollHashId: String, pollItemIds: [Int], voterName: String?) async -> Result<Void, NetworkError>
    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async -> Result<Void, NetworkError>
    func cancelVote(votingId: Int) async -> Result<Void, NetworkError>
    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async -> Result<Void, NetworkError>
    func getPushNotificationHistory(page: Int, size: Int) async -> Result<PushNotificationDatas, NetworkError>
    func createAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError>
    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError>
}
