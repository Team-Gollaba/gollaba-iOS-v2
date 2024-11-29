//
//  ThreeByTwoGridPollDetail.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollDetailContentBySingleGridView: View {
    var poll: PollItem
    @Binding var selectedPoll: Int?
    
    var body: some View {
        ThreeByTwoGridView(itemsCount: poll.items.count) { index in
            SelectablePollContent(
                pollOption: poll.items[index],
                responseType: .single,
                isSelected: index + 1 == selectedPoll,
                action: { selectedPoll = index + 1 }
            )
            .padding(.horizontal, 4)
        }
    }
}

//#Preview {
//    PollDetailContentBySingleGridView(poll: PollItem(, selectedPoll: <#Binding<Int?>#>)
//}
