//
//  UserRepository.swift
//  Gollaba
//

import SwiftUI

protocol UserRepositoryProtocol {
    func fetchUserMe() async throws -> UserData
    func updateName(name: String) async throws
    func updateProfileImage(image: UIImage) async throws
    func deleteProfileImage() async throws
    func deleteAccount() async throws
}

class UserRepositoryImpl: UserRepositoryProtocol {
    func fetchUserMe() async throws -> UserData {
        return try await ApiManager.shared.getUserMe().get()
    }

    func updateName(name: String) async throws {
        try await ApiManager.shared.updateUserName(name: name).get()
    }

    func updateProfileImage(image: UIImage) async throws {
        try await ApiManager.shared.updateUserProfileImage(image: image).get()
    }

    func deleteProfileImage() async throws {
        try await ApiManager.shared.deleteUserProfileImage().get()
    }

    func deleteAccount() async throws {
        try await ApiManager.shared.deleteAccount().get()
    }
}
