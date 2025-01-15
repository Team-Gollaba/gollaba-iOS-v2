//
//  OAuthLoginButton.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct OAuthLoginButton: View {
    var image: Image
    var providerType: ProviderType
    var oAuthPath: String {
        get {
            switch providerType {
            case .kakao:
                "카카오톡으"
            case .google:
                "구글"
            case .apple:
                "애플"
            case .naver:
                "네이버"
            case .github:
                "깃헙으"
            case .none:
                ""
            }
        }
    }
    var oAuthBackgroundColor: Color {
        get {
            switch providerType {
            case .kakao:
                    .kakao
            case .google:
                    .google
            case .apple:
                    .apple
            case .naver:
                    .naver
            case .github:
                    .github
            default:
                    .black
            }
        }
    }
    var oAuthFontColor: Color {
        get {
            switch providerType {
            case .kakao:
                    .black
            case .google:
                    .black
            case .apple:
                    .white
            case .naver:
                    .white
            case .github:
                    .white
            default:
                    .black
            }
        }
    }
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(providerType == .apple ? .white : .black)
                
                Spacer()
                
                Text("\(oAuthPath)로 시작하기")
                    .font(.suitVariable20)
                    .foregroundStyle(oAuthFontColor)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(oAuthBackgroundColor)
                    .shadow(radius: 2)
            )
            .tint(.black)
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .frame(height: 60)
    }
}

#Preview {
    OAuthLoginButton(image: Image("AppIconImage"), providerType: .apple, action: {})
}
