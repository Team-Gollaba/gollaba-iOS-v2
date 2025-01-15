//
//  LoginView.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Image("AppIconImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 50)
                
                
//                OAuthLoginButton(
//                    image: Image("NaverIcon"),
//                    oAuthPath: "네이버",
//                    action: {}
//                )
                AppleLoginButton(handleAppleLogin: { result in
                    Task {
                        await viewModel.appleLogin(result: result)
                    }
                })
                
                
                OAuthLoginButton(
                    image: Image("KakaoIcon"),
                    oAuthPath: "카카오",
                    action: {
                        Task {
                            await viewModel.kakaoLogin()
                        }
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Text("© 2024 Team Gollaba All rights reserved.")
                    .font(.suitVariable12)
                    .foregroundStyle(.copyright)
            }
        }
        .onAppear {
            viewModel.setAuthManager(authManager)
            if let jwtToken = authManager.jwtToken, jwtToken != "" {
                dismiss()
            }
        }
        .onChange(of: authManager.kakaoAuthManager.isLoggedIn) { _, newValue in
            Task {
                if let accessToken = authManager.kakaoAuthManager.accessToken {
                    authManager.jwtToken = await viewModel.login(providerToken: accessToken, providerType: .kakao)
                    viewModel.accessToken = accessToken
                    viewModel.email = authManager.kakaoAuthManager.userMail
                    viewModel.providerType = .kakao
                    if !viewModel.isNotSignUp && newValue {
                        dismiss()
                    } else {
                        viewModel.goToSignUp = true
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.goToSignUp) {
            SignUpView(accessToken: viewModel.accessToken, email: viewModel.email, providerType: viewModel.providerType)
        }
    }
}

#Preview {
    LoginView()
}


