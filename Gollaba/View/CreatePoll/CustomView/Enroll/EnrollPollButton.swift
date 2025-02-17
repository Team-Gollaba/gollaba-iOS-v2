//
//  EnrollPollButton.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct EnrollPollButton: View {
    var enable: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("등록")
                .font(.suitBold20)
                .padding(8)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(enable ? .enrollButton : .gray)
                )
                .shadow(radius: 5)
        }
        .disabled(!enable)
    }
}

#Preview {
    EnrollPollButton(enable: true, action: {})
}
