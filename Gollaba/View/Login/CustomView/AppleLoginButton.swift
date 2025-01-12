//
//  AppleLoginButton.swift
//  Gollaba
//
//  Created by 김견 on 1/12/25.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                Logger.shared.log(String(describing: self), #function, "Success to apple login. \(auth)")
                
                if let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential {
                    let userId = appleIDCredential.user
                    let fullName = appleIDCredential.fullName
                    let email = appleIDCredential.email
                    Logger.shared.log(String(describing: self), #function, "userId: \(userId), fullName: \(fullName), email: \(email)")
                    
                    if let identityToken = appleIDCredential.identityToken, let tokenString = String(data: identityToken, encoding: .utf8) {
                        Logger.shared.log(String(describing: self), #function, "identityToken: \(tokenString)")
                    }
                    
                    if let authorizationCode = appleIDCredential.authorizationCode, let authCodeString = String(data: authorizationCode, encoding: .utf8) {
                        Logger.shared.log(String(describing: self), #function, "authorizationCode: \(authCodeString)")
                    }
                }
            case .failure(let error):
                Logger.shared.log(String(describing: self), #function, "Failed to apple login with error: \(error)", .error)
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 60)
        .padding()
        .cornerRadius(3)

    }
}

#Preview {
    AppleLoginButton()
}
