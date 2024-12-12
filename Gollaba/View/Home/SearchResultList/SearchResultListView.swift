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
    @State var viewModel: SearchResultListViewModel
    
    init(title: String) {
        self.title = title
        self.viewModel = SearchResultListViewModel(query: title)
    }
    
    var body: some View {
        VStack {
            if viewModel.searchResultPollData?.items.count == 0 {
                Spacer()
                
                Text("검색 결과가 없습니다.")
                    .font(.suitBold32)
                
                Spacer()
            } else {
                ScrollView {
                    
                    VerticalPollList(
                        pollList: viewModel.searchResultPollData?.items ?? [],
                        requestAddPoll: $viewModel.requestAddPoll,
                        isEnd: $viewModel.isEnd
                    )
                    .onChange(of: viewModel.requestAddPoll) { _, newValue in
                        if newValue {
                            Task {
                                await viewModel.fetchMoreResult()
                            }
                        }
                    }
                    
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.getSearchResult()
            }
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
                Text("\'\(title)\' 검색 결과")
                    .font(.suitBold16)
            }
        }
    }
}

#Preview {
    SearchResultListView(title: "title")
}

