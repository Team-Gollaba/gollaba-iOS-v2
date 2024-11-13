//
//  AllPollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct AllPollContent: View {
    var state: String
    var title: String
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(title)
                    .font(.suit_variable20)
                
                Spacer()
                
                PollStateView(state: state)
            }
            .padding(.top, 10)
            .padding(.bottom, 16)
            
            PollChartView(title: "1번", allCount: 10, selectedCount: 7)
            PollChartView(title: "2번", allCount: 10, selectedCount: 3)
            
            HStack {
                Text("04월 03일 까지 · 조회수 4회")
                    .font(.suit_variable16)
                    .foregroundStyle(.gray.opacity(0.7))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "star")
                        .foregroundStyle(.gray)
                }
                
                Button {
                    
                } label: {
                    Text("투표하기")
                        .font(.suit_variable16)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(
                            Rectangle()
                                .foregroundStyle(.gray.opacity(0.3))
                                .cornerRadius(8)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(.white)
        .cornerRadius(10)
        .background(
            Rectangle()
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
        )
        .padding(10)
    }
}

#Preview {
    AllPollContent(state: "state", title: "title")
}
