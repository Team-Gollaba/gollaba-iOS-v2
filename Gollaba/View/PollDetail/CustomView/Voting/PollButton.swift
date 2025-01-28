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
    case notChanged
    
    var title: String {
        switch self {
        case .normal: return "투표하기"
        case .completed, .notChanged: return "재투표하기"
        case .ended: return "이미 종료된 투표입니다."
        }
    }
    
    var pollColor: Color {
        switch self {
        case .normal, .completed: return .pollButton
        case .ended, .notChanged: return .pollEndedBackground
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
                Image(systemName: "person.fill.checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(pollbuttonState.title)
                    .font(.suitBold16)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(pollbuttonState.pollColor)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(pollbuttonState.pollColor, lineWidth: 1)
            )
        }
        .disabled(pollbuttonState == .ended)
    }
}

#Preview {
    PollButton(pollbuttonState: .constant(.ended), action: {})
}
