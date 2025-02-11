//
//  ChooseTwoOptionsView.swift
//  Gollaba
//
//  Created by 김견 on 11/14/24.
//

import SwiftUI

enum Option: CaseIterable {
    case first
    case second
}

struct ChooseTwoOptionsView: View {
    @Binding var selectedOption: Option

    var firstOptionText: String
    var firstOptionImage: Image
    var secondOptionText: String
    var secondOptionImage: Image

    var body: some View {
        VStack {
            optionButton(option: .first, text: firstOptionText, image: firstOptionImage)
            optionButton(option: .second, text: secondOptionText, image: secondOptionImage)
        }
        .tint(.black)
    }
    
    private func optionButton(option: Option, text: String, image: Image) -> some View {
        let isSelected = selectedOption == option
        
        return Button {
            withAnimation {
                selectedOption = option
            }
        } label: {
            HStack {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                
                Text(text)
                    .font(.suitVariable20)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? Color.selectedPoll : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(isSelected ? Color.selectedPoll : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    ChooseTwoOptionsView(
        selectedOption: .constant(.first),
        firstOptionText: "First",
        firstOptionImage: Image("AppIconImage"),
        secondOptionText: "Second",
        secondOptionImage: Image("AppIconImage")
    )
}
