//
//  PollChartView.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct PollChartView: View {
    var title: String
    var allCount: Int
    var selectedCount: Int
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(title)
                    .font(.suitVariable16)
                
                Spacer()
                
                Text("\(selectedCount)명")
                    .font(.suitBold12)
                    .foregroundStyle(.gray)
            }
            ZStack (alignment: .leading) {
                Rectangle()
                    .foregroundStyle(.gray.opacity(0.3))
                
                GeometryReader { geometry in
                    Rectangle()
                        .frame(width: allCount > 0 ? geometry.size.width * CGFloat(selectedCount) / CGFloat(allCount) : 0)
                        .cornerRadius(10)
                        .foregroundStyle(.green)
//                        .animation(.bouncy, value: selectedCount)
//                        .animation(.bouncy, value: allCount)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 12)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 4)
    }
}

#Preview {
    PollChartView(title: "title", allCount: 10, selectedCount: 7)
}
