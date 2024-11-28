//
//  ThreeByTwoGridView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct ThreeByTwoGridView<Content: View>: View {
    let itemsCount: Int
    let columns: [GridItem]
    let spacing: CGFloat
    let content: (Int) -> Content
    
    init(
        itemsCount: Int,
        columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())],
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.itemsCount = itemsCount
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(0..<itemsCount, id: \.self) { index in
                content(index)
            }
        }
    }
}
