//
//  UserRepository.swift
//  Gollaba
//

import SwiftUI

protocol UserRepository {
    func fetchUserMe() async throws -> UserData
    func updateName(name: String) async throws
    func updateProfileImage(image: UIImage) async throws
    func deleteProfileImage() async throws
    func deleteAccount() async throws
}
