//
//  SearchResultListView.swift
//  Gollaba
//
//  Created by 김견 on 12/12/24.
//

import SwiftUI
import AlertToast

struct SearchResultListView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: SearchResultListViewModel
    
    init(searchText: String) {
        self.viewModel = SearchResultListViewModel(query: searchText)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack (spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            
                    }
                    .tint(.black)
                    
                    
                    SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocused) {
                        Task {
                            if viewModel.isValidSearchText() {
                                await viewModel.getSearchResultByFilter()
                            }
                        }
                    }
                    
                    SearchFilterButton(isFilterOpen: $viewModel.isFilterOpen)
                    
                }
                .padding(.leading)
                .padding(.vertical, 0)
                
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
                                    await viewModel.fetchMoreResultByFilter()
                                }
                            }
                        }
                        
                    }
                }
            }
            if viewModel.isFilterOpen {
                SearchFilterView(
                    isFilterOpen: $viewModel.isFilterOpen,
                    sortedBy: $viewModel.sortedBy,
                    pollTypeFilter: $viewModel.pollTypeFilter,
                    isActiveFilter: $viewModel.isActiveFilter,
                    applyAction: {
                        if viewModel.isValidSearchText() {
                            Task {
                                await viewModel.getSearchResultByFilter()
                            }
                        }
                    }
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                if viewModel.searchResultPollData?.items.isEmpty ?? true && !viewModel.isEnd {
                    await viewModel.getSearchResult()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .tint(.black)
//                }
//            }
//            
//            ToolbarItem(placement: .principal) {
//                //                Text("\'\(viewModel.searchText)\' 검색 결과")
//                //                    .font(.suitBold16)
//                
//                HStack (spacing: 12) {
//                    SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocused) {
//                        
//                    }
//                    
//                    SearchFilterButton(isFilterOpen: $viewModel.isFilterOpen)
//                        .padding(.leading, -12)
//                }
//            }
//        }
        .toast(
            isPresenting: $viewModel.showSearchErrorToast) {
                AlertToast(type: .error(.red), title: "검색할 키워드를 입력해주세요.", style: .style(titleFont: .suitBold16))
            }
    }
}

#Preview {
    SearchResultListView(searchText: "title")
}

