@testable import Gollaba
import UIKit

final class MockUserUseCase: UserUseCaseProtocol {
    var getUserMeResult: Result<UserData, NetworkError> = .success(UserData.mock)
    var updateUserNameResult: Result<Void, NetworkError> = .success(())
    var updateProfileImageResult: Result<Void, NetworkError> = .success(())
    var deleteProfileImageResult: Result<Void, NetworkError> = .success(())
    var deleteAccountResult: Result<Void, NetworkError> = .success(())

    var getUserMeCallCount = 0
    var updateUserNameCallCount = 0
    var lastUpdatedName: String?

    func getUserMe() async -> Result<UserData, NetworkError> {
        getUserMeCallCount += 1
        return getUserMeResult
    }

    func updateUserName(name: String) async -> Result<Void, NetworkError> {
        updateUserNameCallCount += 1
        lastUpdatedName = name
        return updateUserNameResult
    }

    func updateUserProfileImage(image: UIImage) async -> Result<Void, NetworkError> {
        return updateProfileImageResult
    }

    func deleteUserProfileImage() async -> Result<Void, NetworkError> {
        return deleteProfileImageResult
    }

    func deleteAccount() async -> Result<Void, NetworkError> {
        return deleteAccountResult
    }
}

// MARK: - UserData helper
extension UserData {
    static var mock: UserData {
        UserData(name: "테스트유저", email: "test@test.com", roleType: "USER", providerType: "KAKAO", profileImageUrl: nil, backgroundImageUrl: nil)
    }
}
