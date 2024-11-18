//
//  PopularPollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/9/24.
//

import SwiftUI

struct PollContent: View {
    var state: String
    var title: String
    var info: String
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                PollStateView(state: state)
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    
                
                Text(title)
                    .font(.suitVariable20)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
                Spacer()
                
                Text(info)
                    .font(.suitVariable16)
                    .foregroundStyle(Color.pollContentInfoFontColor)
                    .padding(20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: 180)
        }
        .frame(width: 300)
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
    PollContent(state: "종료", title: "코카콜라 vs 펩시", info: "07월 30일 종료 4명 참여")
}
