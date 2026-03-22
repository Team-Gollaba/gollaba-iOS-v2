//
//  LoginViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI
import AuthenticationServices

@Observable
class LoginViewModel {
    //MARK: - Properties
    init(authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
    }

    //MARK: - Flag
    private(set) var isNotSignUp: Bool = false
    var goToSignUp: Bool = false
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    //MARK: - Data
    var accessToken: String = ""
    var email: String = ""
    var providerType: ProviderType = .apple
    var providerId: String?
    
    private var authManager: AuthManager?
    private(set) var isAppleLogin: Bool = false
    private let authUseCase: AuthUseCaseProtocol
    
    //MARK: - Login
    func kakaoLogin() async {
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is nil")
            return
        }
        
        do {
            try await authManager.kakaoLogin()
        } catch {
            Logger.shared.log(String(describing: self), #function, "Failed to kakao login with error: \(error)", .error)
            showAlert = true
            alertMessage = "카카오 로그인에 실패했습니다."
        }
    }
    
    func appleLogin(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let auth):
            Logger.shared.log(String(describing: self), #function, "Success to apple login. \(auth)")
            
            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user // 서버 쪽에서 Provider ID
                _ = appleIDCredential.fullName
                self.email = appleIDCredential.email ?? ""
                
                if let authorizationCode = appleIDCredential.authorizationCode, let authCodeString = String(data: authorizationCode, encoding: .utf8) {
                    self.accessToken = authCodeString
                }
                self.authManager?.providerType = .apple
                self.providerId = userId
                self.isAppleLogin = true
            }
        case .failure(let error):
            Logger.shared.log(String(describing: self), #function, "Failed to apple login with error: \(error)", .error)
        }
    }
    
    func login(providerToken: String, providerType: ProviderType) async -> String? {
        let result = await authUseCase.loginByProviderToken(providerToken: providerToken, providerType: providerType)
        switch result {
        case .success(let jwtToken):
            return jwtToken
        case .failure(let error):
            if case .requestFailed(let status) = error, status == NetworkError.notSignUpStatus {
                isNotSignUp = true
            }
            return nil
        }
    }

    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
}
