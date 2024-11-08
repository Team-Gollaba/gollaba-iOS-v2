//
//  TitleView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack {
            Image("AppIconImage")
                .resizable()
                .frame(width: 60, height: 60)
            
            Text("골라바")
                .font(.yangjin30)
                .underline(color: .mainTitleFontColor)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("로그인")
                    .font(.suit_variable16)
                    .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding(.horizontal)
        .background(Color.toolbarBackgroundColor)
    }
}

#Preview {
    TitleView()
}
