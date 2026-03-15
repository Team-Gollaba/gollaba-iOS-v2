@testable import Gollaba
import UIKit

final class MockUserRepository: UserRepositoryProtocol {
    var fetchUserMeResult: Result<UserData, Error> = .success(.mock)
    var updateNameResult: Result<Void, Error> = .success(())
    var updateProfileImageResult: Result<Void, Error> = .success(())
    var deleteProfileImageResult: Result<Void, Error> = .success(())
    var deleteAccountResult: Result<Void, Error> = .success(())

    func fetchUserMe() async throws -> UserData {
        return try fetchUserMeResult.get()
    }

    func updateName(name: String) async throws {
        _ = try updateNameResult.get()
    }

    func updateProfileImage(image: UIImage) async throws {
        _ = try updateProfileImageResult.get()
    }

    func deleteProfileImage() async throws {
        _ = try deleteProfileImageResult.get()
    }

    func deleteAccount() async throws {
        _ = try deleteAccountResult.get()
    }
}
