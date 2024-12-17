//
//  SearchFilterView.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI

struct SearchFilterButton: View {
    @Binding var isFilterOpen: Bool
    
    var body: some View {
        Button {
            isFilterOpen = true
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
        .contentShape(Rectangle())
        .tint(.black)
        .padding(.trailing)
    }
}

#Preview {
    SearchFilterButton(isFilterOpen: .constant(false))
}
