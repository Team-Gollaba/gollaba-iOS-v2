//
//  PollParticipatedList.swift
//  Gollaba
//
//  Created by 김견 on 1/10/25.
//

import SwiftUI

struct PollParticipatedList: View {
    let pollParticipatedList: [PollItem]
    
    @Binding var requestAddPoll: Bool
    @Binding var isEnd: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack (alignment: .leading) {
                if !pollParticipatedList.isEmpty {
                    ForEach(pollParticipatedList, id: \.self) { poll in
                        PollParticipatedView(poll: poll)
                    }
                    
                    Color.clear
                        .frame(height: 0)
                        .id("Bottom")
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                                        if newValue < UIScreen.main.bounds.height + 100 && !isEnd {
                                            requestAddPoll = true
                                        }
                                    }
                            }
                        )
                } else {
                    Text("참여한 투표가 없습니다.\n투표에 참여해보세요!")
                        .font(.suitBold24)
                        .frame(height: 300)
                }
            }
        }
    }
}

#Preview {
    PollParticipatedList(pollParticipatedList: [], requestAddPoll: .constant(false), isEnd: .constant(false))
}
