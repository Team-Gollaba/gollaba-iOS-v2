//
//  RecentSearchKeywordList.swift
//  Gollaba
//
//  Created by 김견 on 1/13/25.
//

import SwiftUI

struct RecentSearchKeywordList: View {
    let recentSearchKeywords: [SearchKeyword]
    let tapAction: (String) -> Void
    let deleteAction: (String) -> Void
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack (spacing: 0) {
                ForEach(recentSearchKeywords) { keyword in
                    RecentSearchKeywordView(
                        keyword: keyword.keyword,
                        tapAction: {
                            tapAction(keyword.keyword)
                        },
                        deleteAction: {
                            deleteAction(keyword.keyword)
                        })
                }
            }
            .padding(4)
            .padding(.trailing)
        }
    }
}

#Preview {
    RecentSearchKeywordList(recentSearchKeywords: [], tapAction: { _ in }, deleteAction: { _ in })
}
