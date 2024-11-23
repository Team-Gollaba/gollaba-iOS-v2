//
//  SelectablePollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct SelectablePollContent: View {
    var isSelected: Bool
    var title: String
    
    var action: () -> Void
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                VStack {
                    Image(systemName: "photo.badge.plus")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .foregroundStyle(.white)
                .background(
                    Color.attach
                )
                
                
                HStack {
                    ZStack {
                        RadioButton(isSelected: isSelected) {
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 24)
                        
                        Text(title)
                            .font(.suitBold16)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 28)
                .background(
                    isSelected ? Color.selectedPoll : Color.toolbarBackground
                )
            }
            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    SelectablePollContent(isSelected: true, title: "title", action: {})
}
