//
//  PollStateViewRibbonStyle.swift
//  Gollaba
//
//  Created by 김견 on 1/7/25.
//

import SwiftUI

struct PollStateViewRibbonStyle: View {
    var state: Bool
    
    var body: some View {
        RibbonShape()
            .fill(state ? Color.enrollButton : Color.pollContentTitleFontColor)
            .frame(width: 60, height: 60)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: -5)
            .overlay(
                Text(state ? "진행 중" : "종료됨")
                    .font(.suitBold16)
                    .foregroundColor(.white)
                    .bold()
                    .rotationEffect(.degrees(45))
                    .offset(x: 10, y: -10)
            )
    }
}

#Preview {
    PollStateViewRibbonStyle(state: true)
}
