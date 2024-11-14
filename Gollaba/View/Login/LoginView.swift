//
//  LoginView.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("AppIconImage")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .padding(.bottom, 50)
            
            
            OAuthLoginButton(
                image: Image("NaverIcon"),
                oAuthPath: "네이버",
                action: {}
            )
            
            OAuthLoginButton(
                image: Image("KakaoIcon"),
                oAuthPath: "카카오",
                action: {}
            )
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
                    .font(.suit_variable12)
                    .foregroundStyle(.copyright)
            }
        }
    }
}

#Preview {
    LoginView()
}


