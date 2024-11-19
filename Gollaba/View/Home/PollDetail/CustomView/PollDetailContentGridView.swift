//
//  ThreeByTwoGridPollDetail.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollDetailContentGridView: View {
    @Binding var pollItemName: [String]
        @Binding var selectedPoll: Int?

        var body: some View {
            ThreeByTwoGridView(itemsCount: pollItemName.count) { index in
                SelectablePollContent(
                    isSelected: index + 1 == selectedPoll,
                    title: pollItemName[index],
                    action: { selectedPoll = index + 1 }
                )
                .padding(.horizontal, 4)
            }
        }
}

#Preview {
    PollDetailContentGridView(pollItemName: .constant([]), selectedPoll: .constant(1))
}
