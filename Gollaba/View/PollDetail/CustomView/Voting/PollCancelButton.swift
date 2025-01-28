//
//  PollCancelButton.swift
//  Gollaba
//
//  Created by 김견 on 1/8/25.
//

import SwiftUI

struct PollCancelButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("투표 취소")
                    .font(.suitBold16)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.red)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.red.opacity(0.7), lineWidth: 1)
            )
        }
    }
}

#Preview {
    PollCancelButton(action: {})
}
