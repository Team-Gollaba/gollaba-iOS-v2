//
//  LoginViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI

@Observable
class LoginViewModel {
    var accessToken: String = ""
    var email: String = ""
    var providerType: ProviderType = .apple
    var isNotSignUp: Bool = false
    var goToSignUp: Bool = false
    
    var authManager: AuthManager?
    
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
}
