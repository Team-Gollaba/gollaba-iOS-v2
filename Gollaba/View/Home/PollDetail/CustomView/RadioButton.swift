//
//  RadioButton.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct RadioButton: View {
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        Circle()
            .stroke(Color.enrollButton, lineWidth: 2)
            .frame(width: 16, height: 16)
            .overlay(
                Circle()
                    .fill(isSelected ? Color.enrollButton : Color.clear)
                    .frame(width: 10, height: 10)
            )
            .onTapGesture {
                onSelect()
            }
    }
}

#Preview {
    RadioButton(isSelected: true, onSelect: {})
}
