//
//  OAuthLoginButton.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct OAuthLoginButton: View {
    var image: Image
    var oAuthPath: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Spacer()
                
                Text("\(oAuthPath) 계정으로 시작하기")
                    .font(.suitVariable20)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.oAuthLoginButtonBorder, lineWidth: 1)
            )
            .tint(.black)
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    OAuthLoginButton(image: Image("AppIconImage"), oAuthPath: "Google", action: {})
}
