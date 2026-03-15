//
//  FavoriteRepository.swift
//  Gollaba
//

import Foundation

protocol FavoriteRepositoryProtocol {
    func addFavorite(pollHashId: String) async throws
    func removeFavorite(pollHashId: String) async throws
    func fetchFavorites() async throws -> [String]
}

class FavoriteRepositoryImpl: FavoriteRepositoryProtocol {
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
