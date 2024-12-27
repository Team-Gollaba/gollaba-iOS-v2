//
//  TitleView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct TitleView: View {
    @Environment(AuthManager.self) var authManager
    @Binding var goToLogin: Bool
    var height: CGFloat
    
    var body: some View {
        HStack (alignment: .center) {
            Image("AppIconImage")
                .resizable()
                .scaledToFill()
                .frame(width: 28, height: 28)
            
            Text("골라바")
                .font(.yangjin20)
                .underline(color: .mainTitleFontColor)
            
            Spacer()
            
            if authManager.isLoggedIn {
                if let profileImageUrl = authManager.kakaoAuthManager.profileImageUrl {
                    TitleProfileView(imageUrl: profileImageUrl, nickName: authManager.kakaoAuthManager.userName)
                }
            } else {
                Button {
                    goToLogin = true
                } label: {
                    Text("로그인")
                        .font(.suitVariable16)
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding(.horizontal)
        .background(Color.toolbarBackgroundColor)
        .background(
            Rectangle()
                .background(Color.toolbarBackgroundColor)
                .cornerRadius(10)
                .shadow(radius: 5)
        )
    }
}

#Preview {
    TitleView(goToLogin: .constant(false), height: 60)
}
