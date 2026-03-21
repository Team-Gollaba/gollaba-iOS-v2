//
//  DefaultFavoriteRepository.swift
//  Gollaba
//

import Foundation

class DefaultFavoriteRepository: FavoriteRepository {
    func addFavorite(pollHashId: String) async throws {
        try await ApiManager.shared.createFavoritePoll(pollHashId: pollHashId).get()
    }

    func removeFavorite(pollHashId: String) async throws {
        try await ApiManager.shared.deleteFavoritePoll(pollHashId: pollHashId).get()
    }

    func fetchFavorites() async throws -> [String] {
        return try await ApiManager.shared.getFavoritePolls().get()
    }
}
