//
//  UserUseCase.swift
//  Gollaba
//

import SwiftUI

protocol UserUseCaseProtocol {
    func getUserMe() async -> Result<UserData, NetworkError>
    func updateUserName(name: String) async -> Result<Void, NetworkError>
    func updateUserProfileImage(image: UIImage) async -> Result<Void, NetworkError>
    func deleteUserProfileImage() async -> Result<Void, NetworkError>
    func deleteAccount() async -> Result<Void, NetworkError>
}

class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepositoryImpl()) {
        self.userRepository = userRepository
    }

    func getUserMe() async -> Result<UserData, NetworkError> {
        do {
            let data = try await userRepository.fetchUserMe()
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func updateUserName(name: String) async -> Result<Void, NetworkError> {
        do {
            try await userRepository.updateName(name: name)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func updateUserProfileImage(image: UIImage) async -> Result<Void, NetworkError> {
        do {
            try await userRepository.updateProfileImage(image: image)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func deleteUserProfileImage() async -> Result<Void, NetworkError> {
        do {
            try await userRepository.deleteProfileImage()
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func deleteAccount() async -> Result<Void, NetworkError> {
        do {
            try await userRepository.deleteAccount()
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }
}
