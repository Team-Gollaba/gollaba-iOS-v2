//
//  SearchFilterContentView.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI

struct SearchFilterContentView: View {
    let title: String
    let firstOption: String
    let secondOption: String
    
    @Binding var selected: [Bool]
    
    private var options: [String] {
        ["선택 안 함", firstOption, secondOption]
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.suitBold16)
                .frame(width: 64, alignment: .leading)
                .padding(.trailing, 8)
            
            ForEach(0..<options.count, id: \.self) { index in
                HStack {
                    OptionSelectButton(
                        isSelected: selected[index],
                        responseType: .single,
                        onSelect: { selectOption(index: index) }
                    )
                    Text(options[index])
                        .font(.suitVariable12)
                }
                .frame(width: 68, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectOption(index: index)
                }
            }
        }
    }
    
    private func selectOption(index: Int) {
        selected = Array(repeating: false, count: options.count)
        selected[index] = true
    }
}

#Preview {
    SearchFilterContentView(title: "기명/익명", firstOption: "first", secondOption: "second", selected: .constant([false, false, false]))
}
