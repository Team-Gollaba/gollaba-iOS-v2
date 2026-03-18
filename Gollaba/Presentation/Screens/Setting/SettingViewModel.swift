//
//  SettingViewModel.swift
//  Gollaba
//
//  Created by 김견 on 1/22/25.
//

import SwiftUI
import PhotosUI

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

    //MARK: - AppStorageData
    var isNotificationOn: Bool = AppStorageManager.shared.isNotificationEnabled
    var appStorageManager: AppStorageManager = AppStorageManager.shared

    //MARK: - Data
    var selectedItem: PhotosPickerItem?
    var postImage: Image?
    var uiImage: UIImage?

    var nickName: String = ""
    var nickNameFocused: Bool = false

    var changeProfileImage: ChangeProfileImage = .none

    var nicknameError: NickNameError = .None
    private(set) var errorMessage: String = ""

    var authManager: AuthManager?

    //MARK: - Initialize
    init(
        pushNotificationUseCase: PushNotificationUseCaseProtocol = PushNotificationUseCase(),
        userUseCase: UserUseCaseProtocol = UserUseCase()
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
        guard let uiImage = self.uiImage else {
            self.errorMessage = "이미지를 선택해주세요."
            self.showErrorDialog = true
            return
        }

        let result = await userUseCase.updateUserProfileImage(image: uiImage)
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

    //MARK: - Image
    func convertImage(item: PhotosPickerItem?) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.postImage = imageSelection.image
        self.uiImage = imageSelection.uiImage
    }

    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }

    func isValidNickname() -> Bool {
        let forbiddenWords = [
            "씨발", "좆", "개새끼", "병신", "미친놈", "엿", "썅", "엿같은", "시발", "썩을", "멍청이", "바보", "븅신", "좃같은", "엿먹어",
            "성기", "야동", "포르노", "섹스", "섹시", "변태", "성인물", "AV", "자위", "성욕", "야사", "음란", "야설", "발정", "성행위", "강간", "노출",
            "흑인", "백인", "유태인", "장애인", "쪽바리", "중국놈", "왜놈", "일베", "혐오",
            "살인", "테러", "자살", "죽여", "협박", "살인자", "죽음", "무기", "총기", "학살", "납치", "폭발",
            "공산당", "민주당", "공화당", "종북", "나치", "파시스트", "레닌", "이슬람국가", "탈레반",
            "도박", "대출", "사기", "불법", "복권", "대포통장", "카드깡", "마약", "필로폰", "대마초", "아편", "마약사범", "범죄",
            "우울증", "정신병", "발암", "암덩어리", "병자", "쓸모없는", "혐오", "무가치", "비참한", "저주"
        ]

        let specialCharRegex = "[^\\p{L}\\p{N}]"

        if nickName.isEmpty {
            nicknameError = .Empty
            showInValidToast = true
            return false
        } else if nickName.count < 2 || nickName.count > 10 {
            nicknameError = .Length
            showInValidToast = true
            return false
        } else if nickName.contains(" ") {
            nicknameError = .ContainsBlank
            showInValidToast = true
            return false
        } else if let authManager, authManager.userData?.name == nickName {
            nicknameError = .Duplicate
            showInValidToast = true
            return false
        } else if let regex = try? NSRegularExpression(pattern: specialCharRegex, options: []) {
            let range = NSRange(location: 0, length: nickName.utf16.count)
            let matchFound = regex.firstMatch(in: nickName, options: [], range: range) != nil
            if matchFound {
                nicknameError = .SpecialCharacter
                showInValidToast = true
                return false
            }
        }

        for forbiddenWord in forbiddenWords {
            if nickName.contains(forbiddenWord) {
                nicknameError = .ContainsForbiddenCharacter
                showInValidToast = true
                return false
            }
        }
        return true
    }

    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
