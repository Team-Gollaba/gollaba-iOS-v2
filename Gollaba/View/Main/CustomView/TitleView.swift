//
//  TitleView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct TitleView: View {
    @Environment(KakaoAuthManager.self) var kakaoAuthManager
    @Binding var goToLogin: Bool
    var height: CGFloat
    
    var body: some View {
        HStack {
            Image("AppIconImage")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
            
            Text("골라바")
                .font(.yangjin30)
                .underline(color: .mainTitleFontColor)
            
            Spacer()
            
            if kakaoAuthManager.isLoggedIn {
                if let profileImageUrl = kakaoAuthManager.profileImageUrl {
                    TitleProfileView(imageUrl: profileImageUrl, nickName: kakaoAuthManager.userName)
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
