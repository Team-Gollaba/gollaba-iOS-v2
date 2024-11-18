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
    @State var isQuestionPresent: Bool = false
    
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
            
            
            OptionBoxView(title: "투표 종료 기간") {
                CallendarOptionView()
            }
            
            QuestionButton(action: {
                isQuestionPresent = true
            })
            
        }
        .padding(.horizontal)
        .dialog(
            isPresented: $isQuestionPresent,
            title: "투표 만들기 도움말",
            content: Text("기명투표")
                .font(.suitBold16)
            + Text("를 선택하여 로그인 된 사용자의 투표만 받을 수 있어요.")
                .font(.suitVariable16)
            + Text("\n\n복수투표")
                .font(.suitBold16)
            + Text("로 여러 선택지를 동시에 고르도록 할 수 있어요.")
                .font(.suitVariable16)
            + Text("\n\n마감일")
                .font(.suitBold16)
            + Text("을 설정해 투표 기간을 원하는 만큼 지정할 수 있어요.")
                .font(.suitVariable16),
            primaryButtonText: "확인",
            onPrimaryButton: {}
        )
        
    }
}

#Preview {
    CreatePollView()
}
