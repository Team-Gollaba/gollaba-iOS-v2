//
//  PopularPollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/9/24.
//

import SwiftUI

struct PopularPollContent: View {
    var state: String
    var title: String
    var info: String
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(state)
                    .font(.suit_variable12)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .foregroundStyle(Color.pollContentTitleFontColor)
                    .background(Color.pollContentTitleBackgroundColor)
                    .cornerRadius(3)
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    
                
                Text(title)
                    .font(.suit_variable20)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
                Spacer()
                
                Text(info)
                    .font(.suit_variable16)
                    .foregroundStyle(Color.pollContentInfoFontColor)
                    .padding(20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: 180)
        }
        .frame(width: 350)
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
    PopularPollContent(state: "종료", title: "코카콜라 vs 펩시", info: "07월 30일 종료 4명 참여")
}
