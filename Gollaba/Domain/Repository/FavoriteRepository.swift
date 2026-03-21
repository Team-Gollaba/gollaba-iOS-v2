//
//  FavoriteRepository.swift
//  Gollaba
//

import Foundation

protocol FavoriteRepository {
    func addFavorite(pollHashId: String) async throws
    func removeFavorite(pollHashId: String) async throws
    func fetchFavorites() async throws -> [String]
}
