//
//  ChooseTwoOptionsView.swift
//  Gollaba
//
//  Created by 김견 on 11/14/24.
//

import SwiftUI

enum Option {
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
            Button {
                selectedOption = .first
            } label: {
                HStack {
                    firstOptionImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                    
                    Text(firstOptionText)
                        .font(.suitVariable20)
                        
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .foregroundStyle(
                            selectedOption == .first ? Color.selectedPoll : .clear
                        )
                        .cornerRadius(6)
                    )
            }
            
            
            Button {
                selectedOption = .second
            } label: {
                HStack {
                    secondOptionImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                    
                    Text(secondOptionText)
                        .font(.suitVariable20)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .foregroundStyle(
                            selectedOption == .second ? Color.selectedPoll : .clear
                        )
                        .cornerRadius(6)
                    )
            }
        }
        .tint(.black)
    }
}

#Preview {
    ChooseTwoOptionsView(selectedOption: .constant(.first), firstOptionText: "first", firstOptionImage: Image("AppIconImage"), secondOptionText: "second", secondOptionImage: Image("AppIconImage"))
}
