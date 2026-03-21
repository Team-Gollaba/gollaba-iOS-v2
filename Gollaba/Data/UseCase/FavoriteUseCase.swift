//
//  FavoriteUseCase.swift
//  Gollaba
//

import Foundation

protocol FavoriteUseCaseProtocol {
    func createFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError>
    func deleteFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError>
    func getFavoritePolls() async -> Result<[String], NetworkError>
}

class FavoriteUseCase: FavoriteUseCaseProtocol {
    private let favoriteRepository: FavoriteRepository

    init(favoriteRepository: FavoriteRepository = DefaultFavoriteRepository()) {
        self.favoriteRepository = favoriteRepository
    }

    func createFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        do {
            try await favoriteRepository.addFavorite(pollHashId: pollHashId)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func deleteFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        do {
            try await favoriteRepository.removeFavorite(pollHashId: pollHashId)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getFavoritePolls() async -> Result<[String], NetworkError> {
        do {
            let data = try await favoriteRepository.fetchFavorites()
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }
}
