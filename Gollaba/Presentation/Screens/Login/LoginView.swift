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
        
        VStack (spacing: 20) {
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
            //                AppleLoginButton(handleAppleLogin: { result in
            //                    Task {
            //                        await viewModel.appleLogin(result: result)
            //                    }
            //                })
            
            OAuthLoginButton(
                image: Image("kakaoLogo"),
                providerType: .kakao,
                action: {
                    Task {
                        await viewModel.kakaoLogin()
                    }
                }
            )
            
            //            OAuthLoginButton(
            //                image: Image("NaverLogo"),
            //                providerType: .naver,
            //                action: {
            //
            //                }
            //            )
            //
            //            OAuthLoginButton(
            //                image: Image("GoogleLogo"),
            //                providerType: .google,
            //                action: {
            //
            //                }
            //            )
            
            ZStack {
                AppleLoginButton(handleAppleLogin: { result in
                    Task {
                        await viewModel.appleLogin(result: result)
                    }
                })
                
                OAuthLoginButton(
                    image: Image(systemName: "applelogo"),
                    providerType: .apple,
                    action: {
                        
                    }
                )
                .allowsHitTesting(false)
            }
            
            //            OAuthLoginButton(
            //                image: Image("GithubLogo"),
            //                providerType: .github,
            //                action: {
            //
            //                }
            //            )
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
        .onChange(of: viewModel.isAppleLogin, { _, newValue in
            
            Task {
                authManager.jwtToken = await viewModel.login(providerToken: viewModel.accessToken, providerType: .apple)
                viewModel.providerType = .apple
                
                if !viewModel.isNotSignUp && newValue {
                    dismiss()
                } else {
                    viewModel.goToSignUp = true
                }
            }
        })
        .navigationDestination(isPresented: $viewModel.goToSignUp) {
            SignUpView(accessToken: viewModel.accessToken, email: viewModel.email, providerType: viewModel.providerType, providerId: viewModel.providerId)
        }
    }
}

#Preview {
    LoginView()
}


