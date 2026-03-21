//
//  DefaultUserRepository.swift
//  Gollaba
//

import SwiftUI

class DefaultUserRepository: UserRepository {
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
