//
//  TitleView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct TitleView: View {
    @Binding var goToLogin: Bool
    
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
            
            Button {
                goToLogin = true
            } label: {
                Text("로그인")
                    .font(.suit_variable16)
                    .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal)
        .background(Color.toolbarBackgroundColor)
    }
}

#Preview {
    TitleView(goToLogin: .constant(false))
}
