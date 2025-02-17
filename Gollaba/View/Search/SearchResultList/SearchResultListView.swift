//
//  SearchResultListView.swift
//  Gollaba
//
//  Created by 김견 on 12/12/24.
//

import SwiftUI
import AlertToast

struct SearchResultListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SearchResultListViewModel
    
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
            
            if viewModel.isLoading {
                ZStack {
                    Color.gray.opacity(0.5).edgesIgnoringSafeArea(.all)
                    
                    GollabaLoadingView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                if viewModel.searchResultPollData?.items.isEmpty ?? true && !viewModel.isEnd {
                    await viewModel.getSearchResultByFilter()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "검색 오류",
            content: Text("\(viewModel.errorMessage)")
        )
        .toast(
            isPresenting: $viewModel.showKeywordEmptyErrorToast) {
                AlertToast(type: .error(.red), title: "검색할 키워드를 입력해주세요.", style: .style(titleFont: .suitBold16))
            }
    }
}

#Preview {
    SearchResultListView(searchText: "title")
}

