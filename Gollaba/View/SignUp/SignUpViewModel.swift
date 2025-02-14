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

class SignUpViewModel: ObservableObject {
    //MARK: - Properties
    
    //MARK: - Flag
    @Published var showAlert: Bool = false
    @Published var showInValidToast: Bool = false
    @Published var showCheckBeforeSignUpDialog: Bool = false
    
    //MARK: - Data
    @Published var providerAccessToken: String = ""
    @Published var email: String = ""
    @Published var nickName: String = ""
    @Published var providerType: ProviderType = .apple
    @Published var providerId: String = ""
    @Published var profileImageUrl: String?
    
    @Published var emailFocused: Bool = false
    @Published var nickNameFocused: Bool = false
    
    //MARK: - Image
    @Published var selectedItem: PhotosPickerItem?
    @Published var image: Image?
    @Published var uiImage: UIImage?
    
    //MARK: - Error
    @Published var alertMessage: String = ""
    @Published private(set) var nicknameError: NickNameError = .None
    
    
    func convertImage(item: PhotosPickerItem?) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        
        DispatchQueue.main.async {
            self.image = imageSelection.image
            self.uiImage = imageSelection.uiImage
        }
    }
    
    func signUp() async -> String? {
        do {
            let url = await uploadImage()
            if url != "" {
                let jwtToken: String
                switch providerType {
                case .apple:
                    jwtToken = try await ApiManager.shared.signUp(email: email, name: nickName, profileImageUrl: url, providerType: providerType, providerId: providerId)
                default:
                    jwtToken = try await ApiManager.shared.signUp(email: email, name: nickName, profileImageUrl: url, providerType: providerType, providerAccessToken: providerAccessToken)
                }
                return jwtToken
            }
        } catch {
            handleError(error: error)
        }
        return nil
    }
    
    func uploadImage() async -> String? {
        do {
            if let uiImage = uiImage {
                let url = try await ApiManager.shared.uploadImage(images: [uiImage])
                return url.first ?? ""
            } else {
                return profileImageUrl
            }
        } catch {
            handleError(error: error)
        }
        return nil
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
    
    func handleError(error: Error) {
        self.alertMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showAlert = true
    }
}
