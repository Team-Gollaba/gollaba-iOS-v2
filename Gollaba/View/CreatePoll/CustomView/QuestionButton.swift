//
//  QuestionButton.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct QuestionButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image("QuestionIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    QuestionButton(action: {})
}
