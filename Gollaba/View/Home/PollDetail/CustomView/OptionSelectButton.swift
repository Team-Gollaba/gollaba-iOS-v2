//
//  RadioButton.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct OptionSelectButton: View {
    var isSelected: Bool
    var responseType: ResponseType
    var onSelect: () -> Void
    
    var body: some View {
        if responseType == .single {
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
        } else if responseType == .multiple {
            if isSelected {
                Image(systemName: "checkmark.square.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.enrollButton)
            } else {
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.enrollButton, lineWidth: 2)
                    .frame(width: 14, height: 14)
            }
        }
    }
}

#Preview {
    OptionSelectButton(isSelected: true, responseType: .multiple, onSelect: {})
}
