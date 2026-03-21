//
//  AuthUseCase.swift
//  Gollaba
//

import SwiftUI

protocol AuthUseCaseProtocol {
    func loginByProviderToken(providerToken: String, providerType: ProviderType) async -> Result<String, NetworkError>
    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async -> Result<String, NetworkError>
    func uploadImage(images: [UIImage]) async -> Result<[String], NetworkError>
}

class AuthUseCase: AuthUseCaseProtocol {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = DefaultAuthRepository()) {
        self.authRepository = authRepository
    }

    func loginByProviderToken(providerToken: String, providerType: ProviderType) async -> Result<String, NetworkError> {
        do {
            let token = try await authRepository.loginByProviderToken(providerToken: providerToken, providerType: providerType)
            return .success(token)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func signUp(email: String, name: String, profileImageUrl: String?, providerType: ProviderType, providerAccessToken: String?, providerId: String?) async -> Result<String, NetworkError> {
        do {
            let token = try await authRepository.signUp(
                email: email, name: name,
                profileImageUrl: profileImageUrl,
                providerType: providerType,
                providerAccessToken: providerAccessToken,
                providerId: providerId
            )
            return .success(token)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func uploadImage(images: [UIImage]) async -> Result<[String], NetworkError> {
        do {
            let urls = try await authRepository.uploadImage(images: images)
            return .success(urls)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }
}
