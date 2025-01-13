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
            HStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.suitBold16)
                    .frame(width: 64, alignment: .leading)
                    .padding(.trailing, 8)
                
                ForEach(0..<options.count, id: \.self) { index in
                    HStack(spacing: 4) {
                        OptionSelectButton(
                            isSelected: selected[index],
                            responseType: .single,
                            onSelect: { selectOption(index: index) }
                        )
                            .frame(width: 20, height: 20)
                        
                        Text(options[index])
                            .font(.suitVariable12)
                            
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selected[index] ? .enrollButton.opacity(0.2) : Color.gray.opacity(0.1))
                    )
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
    SearchFilterContentView(title: "기명/익명", firstOption: "기명", secondOption: "익명", selected: .constant([true, false, false]))
}
