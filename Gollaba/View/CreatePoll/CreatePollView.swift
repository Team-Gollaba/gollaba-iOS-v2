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
    
    var body: some View {
        VStack {
            OptionBoxView(title: "투표 제목") {
                TextField("투표의 제목을 입력해주세요.", text: $text)
            }
            
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
        .padding(.horizontal)
    }
}

#Preview {
    CreatePollView()
}
