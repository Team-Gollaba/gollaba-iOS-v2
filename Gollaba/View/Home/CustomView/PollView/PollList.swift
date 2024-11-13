//
//  PopularPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/9/24.
//

import SwiftUI

struct PopularPollList: View {
    let title: String = "🏆 Top 10"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.suit_variable20)
                .padding(.leading, 10)
                .padding(.vertical, 5)
            
            
                ScrollView(.horizontal) {
                    HStack {
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                        PopularPollContent(state: "종료", title: "제목", info: "자ㅓㅇ보")
                    }
                }
                
            
        }
    }
}

#Preview {
    PopularPollList()
}
