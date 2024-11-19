//
//  PollStateView.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct PollStateView: View {
    var state: String
    
    var body: some View {
        Text(state)
            .font(.suitVariable16)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(Color.white)
            .background(Color.pollContentTitleFontColor)
            .cornerRadius(3)
    }
}

#Preview {
    PollStateView(state: "state")
}
