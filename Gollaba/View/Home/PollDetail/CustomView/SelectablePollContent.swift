//
//  SelectablePollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import Kingfisher


struct SelectablePollContent: View {
    var pollOption: PollOption
    
    var responseType: ResponseType
    var isSelected: Bool

    
    var action: () -> Void
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                VStack {
                    if let imageUrl = pollOption.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    } else {
                        Image(systemName: "photo.badge.plus")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .foregroundStyle(.white)
                .background(
                    Color.attach
                )
                
                
                HStack {
                    ZStack {
                        OptionSelectButton(isSelected: isSelected, responseType: responseType) {
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 24)
                        
                        Text(pollOption.description)
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
    SelectablePollContent(pollOption: PollOption(id: 1, description: "des", imageUrl: nil, votingCount: 1), responseType: .multiple, isSelected: true, action: {})
}
