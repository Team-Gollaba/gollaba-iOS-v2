//
//  SignUpButtonView.swift
//  Gollaba
//
//  Created by 김견 on 12/2/24.
//

import SwiftUI

struct SignUpButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("가입")
                .font(.suitBold24)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.signUpButtonStart, .signUpButtonEnd]),
                        startPoint: .leading,
                        endPoint: .trailing
                        )
                )
                .cornerRadius(8)
        }
    }
}

#Preview {
    SignUpButtonView(action: {})
}
