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
        HStack {
            Button {
                selectedOption = .first
            } label: {
                HStack {
                    firstOptionImage
                        .resizable()
                        
                        .frame(width: 30, height: 30)
                    
                    Text(firstOptionText)
                        .font(.suit_variable20)
                        
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Rectangle()
                        .foregroundStyle(
                            selectedOption == .first ? Color.selectedPoll : .clear
                        )
                        .cornerRadius(6)
                    )
            }
            .padding(.trailing, 10)
            
            Button {
                selectedOption = .second
            } label: {
                HStack {
                    secondOptionImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                    
                    Text(secondOptionText)
                        .font(.suit_variable20)
                }
                .padding()
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
