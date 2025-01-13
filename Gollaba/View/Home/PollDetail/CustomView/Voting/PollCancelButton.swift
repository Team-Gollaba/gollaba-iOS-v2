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
                    .frame(width: 12, height: 12)
                    .foregroundStyle(.white)
                
                Text("투표 취소")
                    .font(.suitBold16)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(width: 104)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.red.opacity(0.7), lineWidth: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.red)
                    )
                
            )
        }
        .tint(.white)
    }
}

#Preview {
    PollCancelButton(action: {})
}
