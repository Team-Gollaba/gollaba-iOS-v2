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
            .font(.suitVariable12)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .foregroundStyle(Color.pollContentTitleFontColor)
            .background(Color.pollContentTitleBackgroundColor)
            .cornerRadius(3)
    }
}

#Preview {
    PollStateView(state: "state")
}
