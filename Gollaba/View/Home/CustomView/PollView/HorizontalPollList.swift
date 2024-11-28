//
//  PopularPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/9/24.
//

import SwiftUI

struct HorizontalPollList: View {
    var icon: Image?
    var title: String
    @Binding var goToPollDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                icon?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.yangjin20)
                    
            }
            .padding(.leading, 16)
            .padding(.vertical, 5)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        ForEach(0..<10) { _ in
//                            PollContentWebStyle(title: "제목", endDate: Date(), state: "종료됨", options: ["코카콜라", "펩시"], action: {
//                                goToPollDetail = true
//                            })
//                            .frame(width: 320)
//                        }
                    }
                }
                
            
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    HorizontalPollList(title: "Title", goToPollDetail: .constant(false))
}
