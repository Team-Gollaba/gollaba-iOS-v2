//
//  RecommendKeywordList.swift
//  Gollaba
//
//  Created by 김견 on 1/13/25.
//

import SwiftUI

struct TrendingKeywordList: View {
    let trendingKeywords: [TrendingSearchResponseData]
    let action: (String) -> Void
    
    var body: some View {
        VStack {
            ForEach(Array(trendingKeywords.enumerated()), id: \.offset) { index, trendingKeyword in
                HStack {
                    Button {
                        action(trendingKeyword.searchedWord)
                    } label: {
                        
                        Text("\(index + 1) ")
                            .font(.suitBold16)
                            .foregroundStyle((1...3).contains(index + 1) ? .enrollButton : .black)
                        
                        Text(trendingKeyword.searchedWord)
                            .font(.suitVariable16)
                        
                    }
                    .tint(.black)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    TrendingKeywordList(trendingKeywords: [], action: {_ in })
}
