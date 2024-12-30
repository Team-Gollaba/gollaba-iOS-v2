//
//  PollMadeByMeListView.swift
//  Gollaba
//
//  Created by 김견 on 12/23/24.
//

import SwiftUI

struct PollMadeByMeListView: View {
    let pollMadeByMeList: [PollItem]
    
    @Binding var requestAddPoll: Bool
    @Binding var isEnd: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
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
            }
        }
    }
}

#Preview {
    PollMadeByMeListView(pollMadeByMeList: [], requestAddPoll: .constant(false), isEnd: .constant(false))
}
