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
            HStack (spacing: 20) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                
                Text("로그아웃")
                    .font(.suitBold16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.pollContentTitleFont)
                    .shadow(radius: 5)
            )
        }
        .tint(.white)
        .padding(.horizontal)
    }
}

#Preview {
    LogoutButton(action: {})
}
