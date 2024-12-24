//
//  PollMadeByMeListView.swift
//  Gollaba
//
//  Created by 김견 on 12/23/24.
//

import SwiftUI

struct PollMadeByMeListView: View {
    let pollMadeByMeList: [PollItem]
    
    var body: some View {
        VStack {
            ForEach(pollMadeByMeList, id: \.self) { poll in
                
                PollMadeByMeView(poll: poll)
                
            }
        }
    }
}

#Preview {
    PollMadeByMeListView(pollMadeByMeList: [])
}
