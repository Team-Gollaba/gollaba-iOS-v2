//
//  PollMadeByMeListView.swift
//  Gollaba
//
//  Created by 김견 on 12/23/24.
//

import SwiftUI

struct PollListMadeByMe: View {
    let pollMadeByMeList: [PollItem]
    
    @Binding var requestAddPoll: Bool
    @Binding var isEnd: Bool
    @Binding var activateAnimation: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack (alignment: .leading) {
                if !pollMadeByMeList.isEmpty {
                    ForEach(pollMadeByMeList, id: \.self) { poll in
                        
                        PollMadeByMeView(poll: poll)
                        
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
                    Text("만든 투표가 없습니다.\n투표를 만들어 주세요!")
                        .font(.suitBold24)
                }
            }
        }
    }
}

#Preview {
    PollListMadeByMe(pollMadeByMeList: [], requestAddPoll: .constant(false), isEnd: .constant(false), activateAnimation: .constant(false))
}
