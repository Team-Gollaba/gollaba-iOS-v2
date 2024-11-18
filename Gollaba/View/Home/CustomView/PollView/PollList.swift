//
//  PopularPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/9/24.
//

import SwiftUI

struct PollList: View {
    var title: String
    @Binding var goToPollDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.yangjin20)
                .padding(.leading, 16)
                .padding(.vertical, 5)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                        PollContent(state: "종료", title: "제목", info: "정보") {
                            goToPollDetail = true
                        }
                    }
                }
                
            
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    PollList(title: "Title", goToPollDetail: .constant(false))
}
