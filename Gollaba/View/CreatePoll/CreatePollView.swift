//
//  CreatePollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct CreatePollView: View {
    @State var text: String = ""
    @State var anonymousOption: Option = .first
    @State var countingOption: Option = .first
    @State var pollItemName: [String] = [
        "", "", "",
    ]
    
    var body: some View {
        VStack (spacing: 16) {
            OptionBoxView(title: "투표 제목") {
                TextField("투표의 제목을 입력해주세요.", text: $text)
                    .font(.suitVariable16)
            }
            
            ThreeByTwoGrid(pollItemName: $pollItemName)
            
            
            HStack (spacing: 20) {
                
                OptionBoxView(title: "익명 여부") {
                    ChooseTwoOptionsView(
                        selectedOption: $anonymousOption,
                        firstOptionText: "익명 투표",
                        firstOptionImage: Image("AnonymousIcon"),
                        secondOptionText: "기명 투표",
                        secondOptionImage: Image("SignIcon")
                    )
                }
                
                OptionBoxView(title: "투표 가능 옵션 개수") {
                    ChooseTwoOptionsView(
                        selectedOption: $countingOption,
                        firstOptionText: "단일 투표",
                        firstOptionImage: Image("OnlyPollIcon"),
                        secondOptionText: "복수 투표",
                        secondOptionImage: Image("PluralIcon")
                    )
                }
            }
            
            HStack {
                OptionBoxView(title: "투표 종료 기간") {
                    CallendarOptionView()
                }
                
                Button {
                    
                } label: {
                    Image("QuestionIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding()
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CreatePollView()
}
