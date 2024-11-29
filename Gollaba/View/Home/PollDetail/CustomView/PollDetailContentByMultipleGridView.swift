//
//  PollDetailContentByMultipleGridView.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import SwiftUI

struct PollDetailContentByMultipleGridView: View {
    var poll: PollItem
    @Binding var selectedPoll: [Bool]
    
    var body: some View {
        ThreeByTwoGridView(itemsCount: poll.items.count) { index in
            SelectablePollContent(
                pollOption: poll.items[index],
                responseType: .multiple,
                isSelected: selectedPoll[index],
                action: { selectedPoll[index].toggle() }
            )
            .padding(.horizontal, 4)
        }
    }
}
//
//#Preview {
//    PollDetailContentBySingleGridView(pollOptionItems: [], selectedPoll: .constant(1))
//}
