//
//  MyLikePollsCountView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct MyLikePollsCountView: View {
    var countLikePolls: Int
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "heart")
                
                Text("\(countLikePolls) liked votes")
                    .font(.suitVariable16)
            }
            .foregroundStyle(.myPollLikedVotes)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    MyLikePollsCountView(countLikePolls: 42, action: {})
}
