//
//  SearchView.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI
import SwiftData
import AlertToast

struct SearchView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \SearchKeyword.timeStamp, order: .reverse) private var recentKeywords: [SearchKeyword]
    @State var viewModel = SearchViewModel()
    @Binding var isHideTabBar: Bool
    
    var body: some View {
        
        ScrollView {
            VStack {
                HStack (spacing: 12) {
                    SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocus) {
                        
                        if viewModel.isValidSearchText() {
                            viewModel.saveKeyword(viewModel.searchText, context: context)
                            viewModel.goToSearchResult = true
                            //                            Task {
                            //                                await viewModel.getPolls()
                            //
                            //                            }
                        }
                    }
                    .padding()
                    
                    //                    SearchFilterButton(isFilterOpen: $viewModel.isFilterOpen)
                    //                        .padding(.leading, -12)
                }
                
                ZStack {
                    if let items = viewModel.searchResultPollData?.items {
                        ScrollView {
                            
                            if items.isEmpty {
                                VStack {
                                    Text("검색 결과가 없습니다.")
                                        .font(.suitBold24)
                                }
                            } else {
                                VerticalPollList(
                                    pollList: items,
                                    requestAddPoll: $viewModel.requestAddPoll,
                                    isEnd: $viewModel.isEnd
                                )
                                .onChange(of: viewModel.requestAddPoll) { _, newValue in
                                    
                                    //                                    if newValue && viewModel.page != 0 {
                                    //                                        Task {
                                    //                                            await viewModel.fetchMoreResult()
                                    //                                        }
                                    //                                    }
                                }
                            }
                        }
                        
                    } else {
                        Spacer()
                    }
                    
                    
                    VStack {
                        VStack (alignment: .leading) {
                            Text("최근 검색어")
                                .font(.yangjin20)
                            
                            
                            ScrollView (.horizontal, showsIndicators: false) {
                                HStack (spacing: 20) {
                                    ForEach(recentKeywords) { keyword in
                                        RecentSearchKeywordView(
                                            keyword: keyword.keyword,
                                            tapAction: {
                                                viewModel.searchText = keyword.keyword
                                                viewModel.saveKeyword(viewModel.searchText, context: context)
                                                viewModel.goToSearchResult = true
                                            },
                                            deleteAction: {
                                                viewModel.deleteKeyword(keyword.keyword, context: context)
                                            })
                                    }
                                }
                                .padding(4)
                            }
                        }
                        .padding()
                        .background(.white)
                        
                        VStack (alignment: .leading, spacing: 16) {
                            HStack {
                                Text("추천 검색어")
                                    .font(.yangjin20)
                                
                                Spacer()
                            }
                            
                            ForEach(Array(viewModel.recommendedKeywords.enumerated()), id: \.offset) { index, recommendedKeyword in
                                HStack {
                                    Button {
                                        viewModel.searchText = recommendedKeyword
                                        viewModel.goToSearchResult = true
                                    } label: {
                                        
                                        Text("\(index + 1). ")
                                            .font(.suitBold16)
                                            .foregroundStyle(.enrollButton)
                                        
                                        Text(recommendedKeyword)
                                            .font(.suitVariable16)
                                        
                                    }
                                    .tint(.black)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                }
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.searchFocus = false
        }
        .dragToHide(isHide: $isHideTabBar)
        .onAppear {
            viewModel.recentKeywords = recentKeywords
            viewModel.searchFocus = false
            viewModel.searchFocus = true
        }
        .onDisappear {
            viewModel.searchText = ""
            
        }
        .navigationDestination(isPresented: $viewModel.goToSearchResult, destination: {
            SearchResultListView(searchText: viewModel.searchText)
        })
        .toast(
            isPresenting: $viewModel.showSearchErrorToast) {
                AlertToast(type: .error(.red), title: "검색할 키워드를 입력해주세요.", style: .style(titleFont: .suitBold16))
            }
    }
}

#Preview {
    SearchView(isHideTabBar: .constant(false))
}
