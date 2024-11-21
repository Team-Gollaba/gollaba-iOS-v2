//
//  ThreeByTwoGrid.swift
//  Gollaba
//
//  Created by 김견 on 11/16/24.
//

import SwiftUI
import PhotosUI

struct CreatePollContentGridView: View {
    @Binding var pollItemName: [String]
    @Binding var selectedItem: [PhotosPickerItem?]

        var body: some View {
            ThreeByTwoGridView(itemsCount: pollItemName.count) { index in
                if index >=
                    6 {
                    EmptyView()
                } else {
                    
                    PollItemView(
                        pollItemName: $pollItemName[index],
                        selectedItem: $selectedItem,
                        isCreateModel: pollItemName.count == index + 1,
                        isShowDeleteButton: pollItemName.count > 3 && pollItemName.count != index + 1,
                        itemNumber: index + 1,
                        onImageAttach: {},
                        onAddPollItem: { addItem() },
                        onDeletePollItem: { deleteItem(index: index) }
                    )
                    .padding(.horizontal, 4)
                }
            }
        }

        func addItem() {
            if pollItemName.count < 7 { // 최대 6개로 제한
                pollItemName.append("")
            }
        }

        func deleteItem(index: Int) {
            pollItemName.remove(at: index)
        }
}
//
//#Preview {
//    CreatePollContentGridView(pollItemName: .constant(["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]), selectedItem: .constant(PhotosPickerItem(itemIdentifier: "")))
//}
