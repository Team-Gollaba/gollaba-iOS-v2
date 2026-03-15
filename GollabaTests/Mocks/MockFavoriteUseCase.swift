@testable import Gollaba
import Foundation

final class MockFavoriteUseCase: FavoriteUseCaseProtocol {
    var createFavoriteResult: Result<Void, NetworkError> = .success(())
    var deleteFavoriteResult: Result<Void, NetworkError> = .success(())
    var getFavoritePollsResult: Result<[String], NetworkError> = .success([])

    var createFavoriteCallCount = 0
    var deleteFavoriteCallCount = 0
    var lastCreatedHashId: String?
    var lastDeletedHashId: String?

    func createFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        createFavoriteCallCount += 1
        lastCreatedHashId = pollHashId
        return createFavoriteResult
    }

    func deleteFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        deleteFavoriteCallCount += 1
        lastDeletedHashId = pollHashId
        return deleteFavoriteResult
    }

    func getFavoritePolls() async -> Result<[String], NetworkError> {
        return getFavoritePollsResult
    }
}
