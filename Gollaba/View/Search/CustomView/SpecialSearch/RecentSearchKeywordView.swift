//
//  RecentSearchKeywordView.swift
//  Gollaba
//
//  Created by 김견 on 12/20/24.
//

import SwiftUI

struct RecentSearchKeywordView: View {
    let keyword: String
    let tapAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Text(keyword)
                .font(.suitBold16)
                .onTapGesture {
                    tapAction()
                }
            
            Button {
                deleteAction()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .foregroundStyle(.black.opacity(0.6))
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.pollEndedBackground, lineWidth: 1)
        )
        .padding(.leading)
    }
}

#Preview {
    RecentSearchKeywordView(keyword: "keyword", tapAction: {}, deleteAction: {})
}
