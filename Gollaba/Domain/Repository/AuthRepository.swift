//
//  AuthRepository.swift
//  Gollaba
//

import SwiftUI

protocol AuthRepository {
    func loginByProviderToken(providerToken: String, providerType: ProviderType) async throws -> String
    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async throws -> String
    func uploadImage(images: [UIImage]) async throws -> [String]
}
