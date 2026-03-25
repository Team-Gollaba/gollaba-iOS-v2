//
//  SettingViewModel.swift
//  Gollaba
//
//  Created by 김견 on 1/22/25.
//

import SwiftUI

enum ProfileImageError: Error {
    case imageNil
}

enum ChangeProfileImage {
    case toDefault
    case toPhotoLibrary
    case none
}

@Observable
class SettingViewModel {
    //MARK: - Properties
    private let pushNotificationUseCase: PushNotificationUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol

    //MARK: - Flag
    var showErrorDialog: Bool = false
    var showSetProfileImageDialog: Bool = false
    var showSetNicknameDialog: Bool = false
    var showInValidToast: Bool = false
    var showSuccessUpdateUserNameToast: Bool = false
    var showDeleteAccountDialog: Bool = false
    var showQuestionToChangeProfileImageDialog: Bool = false
    var showPHPicker: Bool = false

    //MARK: - AppStorageData
    var isNotificationOn: Bool = AppStorageManager.shared.isNotificationEnabled
    var appStorageManager: AppStorageManager = AppStorageManager.shared

    //MARK: - Data
    var profileImage: UIImage? {
        didSet {
            if profileImage != nil {
                Task {
                    await updateProfileImage()
                    await getUser()
                }
            }
        }
    }

    var nickName: String = ""
    var nickNameFocused: Bool = false

    var changeProfileImage: ChangeProfileImage = .none

    var nicknameError: NickNameError = .None
    private(set) var errorMessage: String = ""

    var authManager: AuthManager?

    //MARK: - Initialize
    init(
        pushNotificationUseCase: PushNotificationUseCaseProtocol,
        userUseCase: UserUseCaseProtocol
    ) {
        self.pushNotificationUseCase = pushNotificationUseCase
        self.userUseCase = userUseCase
    }

    //MARK: - API
    func updateNotification() async {
        let result = await pushNotificationUseCase.updateAppPushNotification(
            agentId: self.appStorageManager.agentId ?? "",
            allowsNotification: self.isNotificationOn
        )

        switch result {
        case .success(()):
            self.appStorageManager.isNotificationEnabled = self.isNotificationOn
        case .failure(let error):
            handleError(error: error)
        }
    }

    func updateProfileImage() async {
        guard let profileImage = self.profileImage else {
            self.errorMessage = "이미지를 선택해주세요."
            self.showErrorDialog = true
            return
        }

        let result = await userUseCase.updateUserProfileImage(image: profileImage)
        if case .failure(let error) = result {
            handleError(error: error)
        }
    }

    func updateUserName() async {
        let result = await userUseCase.updateUserName(name: nickName)
        switch result {
        case .success(()):
            self.authManager?.userData?.name = nickName
            self.showSuccessUpdateUserNameToast = true
        case .failure(let error):
            handleError(error: error)
        }
    }

    func getUser() async {
        let result = await userUseCase.getUserMe()
        switch result {
        case .success(let userData):
            authManager?.userData = userData
            self.nickName = userData.name
        case .failure(let error):
            handleError(error: error)
        }
    }

    func deleteAccount() async {
        guard let authManager else {
            self.errorMessage = "인증 정보를 찾을 수 없습니다."
            self.showErrorDialog = true
            return
        }

        let result = await userUseCase.deleteAccount()
        switch result {
        case .success(()):
            authManager.justDeletedAccount = true
            authManager.resetAuth()
        case .failure(let error):
            handleError(error: error)
        }
    }

    func deleteProfileImage() async {
        let result = await userUseCase.deleteUserProfileImage()
        if case .failure(let error) = result {
            handleError(error: error)
        }
    }

    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }

    func isValidNickname() -> Bool {
        let error = ValidationConstants.validateNickname(nickName, currentName: authManager?.userData?.name)
        if error != .None {
            nicknameError = error
            showInValidToast = true
            return false
        }
        return true
    }

    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
