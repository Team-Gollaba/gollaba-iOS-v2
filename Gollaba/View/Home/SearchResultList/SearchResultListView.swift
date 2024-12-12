//
//  SearchResultListView.swift
//  Gollaba
//
//  Created by 김견 on 12/12/24.
//

import SwiftUI

struct SearchResultListView: View {
    let title: String
    @Environment(\.dismiss) var dismiss
    @State var viewModel = SearchResultListViewModel()
    
    var body: some View {
        VStack {
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("\'\(title)\' 검색결과")
            }
        }
    }
}

#Preview {
    SearchResultListView(title: "title")
}
