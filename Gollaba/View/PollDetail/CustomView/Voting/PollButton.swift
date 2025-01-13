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
    
    var title: String {
        switch self {
        case .normal: return "투표하기"
        case .completed: return "재투표하기"
        case .ended: return "이미 종료된 투표입니다."
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .normal, .completed: return .pollButton
        case .ended: return .pollEndedBackground
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .normal, .completed: return .enrollButton
        case .ended: return .attach
        }
    }
}

struct PollButton: View {
    @Binding var pollbuttonState: PollButtonState
    
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image("PollIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .colorInvert()
                
                Text(pollbuttonState.title)
                    .font(.suitBold16)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(pollbuttonState.strokeColor, lineWidth: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(pollbuttonState.backgroundColor)
                    )
                
            )
        }
        .tint(.white)
        .disabled(pollbuttonState == .ended)
    }
}

#Preview {
    PollButton(pollbuttonState: .constant(.ended), action: {})
}
