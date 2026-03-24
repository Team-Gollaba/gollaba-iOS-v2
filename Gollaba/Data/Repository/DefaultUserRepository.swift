//
//  DefaultUserRepository.swift
//  Gollaba
//

import SwiftUI

class DefaultUserRepository: UserRepository {
    private let apiManager: any ApiManagerProtocol

    init(apiManager: any ApiManagerProtocol = ApiManager.shared) {
        self.apiManager = apiManager
    }

    func fetchUserMe() async throws -> UserData {
        return try await apiManager.getUserMe().get()
    }

    func updateName(name: String) async throws {
        try await apiManager.updateUserName(name: name).get()
    }

    func updateProfileImage(image: UIImage) async throws {
        try await apiManager.updateUserProfileImage(image: image).get()
    }

    func deleteProfileImage() async throws {
        try await apiManager.deleteUserProfileImage().get()
    }

    func deleteAccount() async throws {
        try await apiManager.deleteAccount().get()
    }
}
