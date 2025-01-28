//
//  PollButton.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

enum VotingButtonState {
    case normal
    case completed
    case ended
    case notChanged
    case alreadyVoted
    case cancel
    
    var icon: Image {
        switch self {
        case .normal, .completed, .notChanged: return Image(systemName: "person.fill.checkmark")
        case .ended, .alreadyVoted: return Image(systemName: "checkmark")
        case .cancel: return Image(systemName: "xmark")
        }
    }
    
    var title: String {
        switch self {
        case .normal: return "투표하기"
        case .completed, .notChanged: return "재투표하기"
        case .ended: return "이미 종료된 투표입니다."
        case .alreadyVoted: return "이미 투표하셨습니다."
        case .cancel: return "투표 취소"
        }
    }
    
    var pollColor: Color {
        switch self {
        case .normal, .completed: return .pollButton
        case .ended, .notChanged, .alreadyVoted: return .pollEndedBackground
        case .cancel: return .red
        }
    }
}

struct VotingButton: View {
    @Binding var pollbuttonState: VotingButtonState
    
    var action: () -> Void
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        } label: {
            HStack {
                pollbuttonState.icon
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
                
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
        .disabled(pollbuttonState == .ended || pollbuttonState == .notChanged)
    }
}

#Preview {
    VotingButton(pollbuttonState: .constant(.ended), action: {})
}
