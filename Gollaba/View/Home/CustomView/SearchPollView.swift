//
//  SearchPollView.swift
//  Gollaba
//
//  Created by 김견 on 11/14/24.
//

import SwiftUI

struct SearchPollView: View {
    @Binding var text: String
    
    var body: some View {
        HStack (spacing: 10) {
            Button {
                
            } label: {
                Image("Search")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
            }
            
            TextField("제목으로 투표를 검색하세요.", text: $text)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.searchBorder, lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    SearchPollView(text: .constant(""))
}