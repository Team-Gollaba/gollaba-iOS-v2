//
//  AllPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct AllPollList: View {
    @Binding var goToPollDetail: Bool
    let title: String = "📝 전체 투표"
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.yangjin20)
                .padding(.leading, 16)
                .padding(.vertical, 5)
            
//            AllPollContent(state: "진행 중", title: "투표1")
//            AllPollContent(state: "진행 중", title: "투표2")
//            AllPollContent(state: "진행 중", title: "투표3")
//            AllPollContent(state: "진행 중", title: "투표4")
//            AllPollContent(state: "진행 중", title: "투표5")
//            AllPollContent(state: "진행 중", title: "투표6")
//            AllPollContent(state: "진행 중", title: "투표7")
//            AllPollContent(state: "진행 중", title: "투표8")
//            AllPollContent(state: "진행 중", title: "투표9")
//            AllPollContent(state: "진행 중", title: "투표10")
//            AllPollContent(state: "진행 중", title: "투표11")
//            AllPollContent(state: "진행 중", title: "투표12")
            
            ForEach(0..<10) { _ in
                PollContentWebStyle(title: "제목", endDate: Date(), state: "종료됨", options: ["코카콜라", "펩시"], action: {
                    goToPollDetail = true
                })
            }
        }
    }
}

#Preview {
    AllPollList(goToPollDetail: .constant(false))
}
