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
    
    //MARK: - Flag
    private(set) var isNotSignUp: Bool = false
    var goToSignUp: Bool = false
    
    //MARK: - Data
    var accessToken: String = ""
    var email: String = ""
    var providerType: ProviderType = .apple
    var providerId: String?
    
    private var authManager: AuthManager?
    private(set) var isAppleLogin: Bool = false
    
    //MARK: - Login
    func kakaoLogin() async {
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is nil")
            return
        }
        
        do {
            try await authManager.kakaoLogin()
        } catch {
            
        }
    }
    
    func appleLogin(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let auth):
            Logger.shared.log(String(describing: self), #function, "Success to apple login. \(auth)")
            
            if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user // 서버 쪽에서 Provider ID
                let fullName = appleIDCredential.fullName
                self.email = appleIDCredential.email ?? ""
                Logger.shared.log(String(describing: self), #function, "userId: \(userId), fullName: \(fullName), email: \(email)")
                
                if let identityToken = appleIDCredential.identityToken, let tokenString = String(data: identityToken, encoding: .utf8) {
                    Logger.shared.log(String(describing: self), #function, "identityToken: \(tokenString)")
                }
                
                if let authorizationCode = appleIDCredential.authorizationCode, let authCodeString = String(data: authorizationCode, encoding: .utf8) {
                    self.accessToken = authCodeString
                    Logger.shared.log(String(describing: self), #function, "authorizationCode: \(authCodeString)")
                }
                
                self.providerId = userId
                self.isAppleLogin = true
            }
        case .failure(let error):
            Logger.shared.log(String(describing: self), #function, "Failed to apple login with error: \(error)", .error)
        }
    }
    
    func login(providerToken: String, providerType: ProviderType) async -> String {
        do {
            let jwtToken = try await ApiManager.shared.loginByProviderToken(providerToken: providerToken, providerType: providerType)
            return jwtToken
        } catch {
            if let authError = error as? AuthError, authError == .notSignUp {
                isNotSignUp = true
            }
        }
        return ""
    }

    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
}
