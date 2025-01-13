//
//  SortingView.swift
//  Gollaba
//
//  Created by 김견 on 12/17/24.
//

import SwiftUI

struct SortingView: View {
    @Binding var sortedBy: SortedBy
    let createdAtTitle: String = "생성 날짜 순"
    let endAtTitle: String = "마감 날짜 순"
    
    var body: some View {
        VStack {
            Menu {
                Button {
                    sortedBy = .createdAt
                } label: {
                    Label(createdAtTitle, systemImage: sortedBy == .createdAt ? "checkmark" : "")
                }
                
                Button {
                    sortedBy = .endAt
                } label: {
                    Label(endAtTitle, systemImage: sortedBy == .endAt ? "checkmark" : "")
                }
            } label: {
                Label(sortedBy == .createdAt ? createdAtTitle : endAtTitle, systemImage: "arrow.up.arrow.down")
                    .font(.suitBold12)
                    .foregroundStyle(.white)
                    .padding(4)
                    .background(.enrollButton)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    SortingView(sortedBy: .constant(.createdAt))
}
