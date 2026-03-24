//
//  DefaultAuthRepository.swift
//  Gollaba
//

import SwiftUI

class DefaultAuthRepository: AuthRepository {
    private let apiManager: any ApiManagerProtocol

    init(apiManager: any ApiManagerProtocol = ApiManager.shared) {
        self.apiManager = apiManager
    }

    func loginByProviderToken(providerToken: String, providerType: ProviderType) async throws -> String {
        return try await apiManager.loginByProviderToken(providerToken: providerToken, providerType: providerType).get()
    }

    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async throws -> String {
        return try await apiManager.signUp(
            email: email, name: name,
            profileImageUrl: profileImageUrl,
            providerType: providerType,
            providerAccessToken: providerAccessToken,
            providerId: providerId
        ).get()
    }

    func uploadImage(images: [UIImage]) async throws -> [String] {
        return try await apiManager.uploadImage(images: images).get()
    }
}
