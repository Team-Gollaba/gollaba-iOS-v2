//
//  ThreeByTwoGridPollDetail.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct ThreeByTwoGridPollDetail: View {
    @Binding var pollItemName: [String]
    @Binding var selectedPoll: Int?
    
    let items = Array(1...6)
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items.prefix(pollItemName.count), id: \.self) { item in
                    
                SelectablePollContent(isSelected: item == selectedPoll, title: pollItemName[item - 1], action: {
                    selectedPoll = item
                })
                
                .padding(.horizontal, 4)
            }
        }
        
    }
}

#Preview {
    ThreeByTwoGridPollDetail(pollItemName: .constant([]), selectedPoll: .constant(1))
}
