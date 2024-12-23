//
//  GoToSearchView.swift
//  Gollaba
//
//  Created by 김견 on 12/23/24.
//

import SwiftUI

struct GoToSearchView: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image("Search")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                
                Text("검색으로 투표를 찾아보세요!")
                    .font(.suitVariable16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .tint(.black)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    GoToSearchView(action: {})
}
