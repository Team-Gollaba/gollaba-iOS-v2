//
//  PollButton.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

enum PollButtonState {
    case normal
    case completed
    case ended
}

struct PollButton: View {
    @Binding var pollbuttonState: PollButtonState
    var title: String {
        switch pollbuttonState {
        case .normal:
            return "투표하기"
        case .completed:
            return "재투표하기"
        case .ended:
            return "이미 종료된 투표입니다."
        }
    }
    
    var backgroundColor: Color {
        switch pollbuttonState {
        case .normal, .completed:
            return .pollButton
        case .ended:
            return .pollEndedBackground
        }
    }
    
    var strokeColor: Color {
        switch pollbuttonState {
        case .normal, .completed:
            return .enrollButton
        case .ended:
            return .attach
        }
    }
    
    var body: some View {
        Button {
            pollbuttonState = .completed
        } label: {
            HStack {
                Image("PollIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .colorInvert()
                
                Text(title)
                    .font(.suitBold16)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(strokeColor, lineWidth: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(backgroundColor)
                    )

            )
        }
        .tint(.white)
        .disabled(pollbuttonState == .ended)
    }
}

#Preview {
    PollButton(pollbuttonState: .constant(.ended))
}
