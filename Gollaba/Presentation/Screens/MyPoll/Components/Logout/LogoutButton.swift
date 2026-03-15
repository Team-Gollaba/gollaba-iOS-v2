//
//  LogoutButton.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct LogoutButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack (spacing: 16) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text("로그아웃")
                    .font(.suitBold16)
            }
            .frame(width: 100)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.pollContentTitleFont)
                    .shadow(radius: 5)
            )
        }
        .tint(.white)
        .padding(.vertical, 20)
    }
}

#Preview {
    LogoutButton(action: {})
}
