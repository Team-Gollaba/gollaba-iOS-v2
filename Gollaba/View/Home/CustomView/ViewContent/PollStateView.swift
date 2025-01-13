//
//  PollStateView.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct PollStateView: View {
    var state: Bool
    
    var body: some View {
        Text(state ? "진행 중" : "종료됨")
            .font(.suitVariable16)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(Color.white)
            .background(state ? Color.enrollButton : Color.pollContentTitleFontColor)
            .cornerRadius(3)
    }
}

#Preview {
    PollStateView(state: true)
}
