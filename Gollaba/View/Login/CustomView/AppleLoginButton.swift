//
//  AppleLoginButton.swift
//  Gollaba
//
//  Created by 김견 on 1/12/25.
//

import SwiftUI
import AuthenticationServices

struct AppleLoginButton: View {
    let handleAppleLogin: (Result<ASAuthorization, Error>) -> Void
    
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            handleAppleLogin(result)
        }
        .padding(.horizontal)
        .frame(height: 60)
        .cornerRadius(10)
        .signInWithAppleButtonStyle(.black)
    }
}

#Preview {
    AppleLoginButton(handleAppleLogin: { _ in })
}
