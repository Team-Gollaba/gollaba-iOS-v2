//
//  SignUpViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/3/24.
//

import SwiftUI
import PhotosUI

enum NickNameError {
    case Empty
    case Length
    case ContainsBlank
    case SpecialCharacter
    case ContainsForbiddenCharacter
    case Duplicate
    case None
}

@Observable
class SignUpViewModel {
    //MARK: - Properties
    private let authUseCase: AuthUseCaseProtocol

    //MARK: - Flag
    var showAlert: Bool = false
    var showInValidToast: Bool = false
    var showCheckBeforeSignUpDialog: Bool = false

    //MARK: - Data
    var providerAccessToken: String = ""
    var email: String = ""
    var nickName: String = ""
    var providerType: ProviderType = .apple
    var providerId: String = ""
    var profileImageUrl: String?

    var emailFocused: Bool = false
    var nickNameFocused: Bool = false

    //MARK: - Image
    var selectedItem: PhotosPickerItem?
    var image: Image?
    var uiImage: UIImage?

    //MARK: - Error
    var alertMessage: String = ""
    private(set) var nicknameError: NickNameError = .None

    //MARK: - Initialize
    init(authUseCase: AuthUseCaseProtocol = AuthUseCase()) {
        self.authUseCase = authUseCase
    }

    func convertImage(item: PhotosPickerItem?) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.image = imageSelection.image
        self.uiImage = imageSelection.uiImage
    }

    func signUp() async -> String? {
        let imageUrl: String?
        if let uiImage = uiImage {
            let imageResult = await authUseCase.uploadImage(images: [uiImage])
            switch imageResult {
            case .success(let urls):
                imageUrl = urls.first ?? ""
            case .failure(let error):
                handleError(error: error)
                return nil
            }
        } else {
            imageUrl = profileImageUrl
        }

        let jwtResult: Result<String, NetworkError>
        switch providerType {
        case .apple:
            jwtResult = await authUseCase.signUp(
                email: email, name: nickName,
                profileImageUrl: imageUrl,
                providerType: providerType,
                providerAccessToken: nil,
                providerId: providerId
            )
        default:
            jwtResult = await authUseCase.signUp(
                email: email, name: nickName,
                profileImageUrl: imageUrl,
                providerType: providerType,
                providerAccessToken: providerAccessToken,
                providerId: nil
            )
        }

        switch jwtResult {
        case .success(let jwtToken):
            return jwtToken
        case .failure(let error):
            handleError(error: error)
            return nil
        }
    }

    func uploadImage() async -> String? {
        if let uiImage = uiImage {
            let result = await authUseCase.uploadImage(images: [uiImage])
            switch result {
            case .success(let urls):
                return urls.first ?? ""
            case .failure(let error):
                handleError(error: error)
                return nil
            }
        } else {
            return profileImageUrl
        }
    }

    func isValid() -> Bool {
        if email.isEmpty {
            alertMessage = "이메일을 입력해주세요."
            showAlert = true
            return false
        } else if nickName.isEmpty {
            alertMessage = "닉네임을 입력해주세요."
            showAlert = true
            return false
        } else if !isValidEmail() {
            alertMessage = "이메일을 형식을 맞춰주세요."
            showAlert = true
            return false
        }

        return isValidNickName()
    }

    func isValidEmail() -> Bool {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    func isValidNickName() -> Bool {
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
        self.alertMessage = error.description
        self.showAlert = true
    }
}
