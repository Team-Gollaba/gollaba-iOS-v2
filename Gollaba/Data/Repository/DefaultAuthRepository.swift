//
//  DefaultAuthRepository.swift
//  Gollaba
//

import SwiftUI

class DefaultAuthRepository: AuthRepository {
    func loginByProviderToken(providerToken: String, providerType: ProviderType) async throws -> String {
        return try await ApiManager.shared.loginByProviderToken(providerToken: providerToken, providerType: providerType).get()
    }

    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async throws -> String {
        return try await ApiManager.shared.signUp(
            email: email, name: name,
            profileImageUrl: profileImageUrl,
            providerType: providerType,
            providerAccessToken: providerAccessToken,
            providerId: providerId
        ).get()
    }

    func uploadImage(images: [UIImage]) async throws -> [String] {
        return try await ApiManager.shared.uploadImage(images: images).get()
    }
}
