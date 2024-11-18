//
//  EnrollPollButton.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct EnrollPollButton: View {
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
                        .foregroundStyle(.enrollButton)
                )
        }
    }
}

#Preview {
    EnrollPollButton(action: {})
}
