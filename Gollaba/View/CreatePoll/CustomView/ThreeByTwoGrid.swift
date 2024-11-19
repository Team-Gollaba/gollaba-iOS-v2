//
//  ThreeByTwoGrid.swift
//  Gollaba
//
//  Created by 김견 on 11/16/24.
//

import SwiftUI

struct ThreeByTwoGrid: View {
    @Binding var pollItemName: [String]
    
    let items = Array(1...6)
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items.prefix(pollItemName.count), id: \.self) { item in
                //                PollItemView(pollItemName: $pollItemName[item - 1], isCreateModel: true, itemNumber: item)
                PollItemView(
                    pollItemName: $pollItemName[item - 1],
                    isCreateModel: pollItemName.count == item,
                    isShowDeleteButton: pollItemName.count > 3 && pollItemName.count != item,
                    itemNumber: item,
                    onImageAttach: {},
                    onAddPollItem: {
                        addItem()
                    },
                    onDeletePollItem: {
                        deleteItem(index: item - 1)
                    }
                )
                .padding(.horizontal, 4)
            }
        }
        
    }
    
    func addItem() {
        pollItemName.append("")
    }
    
    func deleteItem(index: Int) {
        pollItemName.remove(at: index)
    }
}

#Preview {
    ThreeByTwoGrid(pollItemName: .constant(["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]))
}
