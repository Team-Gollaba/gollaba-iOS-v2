//
//  DefaultFavoriteRepository.swift
//  Gollaba
//

import Foundation

class DefaultFavoriteRepository: FavoriteRepository {
    private let apiManager: any ApiManagerProtocol

    init(apiManager: any ApiManagerProtocol = ApiManager.shared) {
        self.apiManager = apiManager
    }

    func addFavorite(pollHashId: String) async throws {
        try await apiManager.createFavoritePoll(pollHashId: pollHashId).get()
    }

    func removeFavorite(pollHashId: String) async throws {
        try await apiManager.deleteFavoritePoll(pollHashId: pollHashId).get()
    }

    func fetchFavorites() async throws -> [String] {
        return try await apiManager.getFavoritePolls().get()
    }
}
