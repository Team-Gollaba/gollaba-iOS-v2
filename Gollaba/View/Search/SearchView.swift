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
                        SpecialSearchContentView(
                            title: "최근 검색어",
                            image: Image(systemName: "stopwatch"),
                            imageColor: .signUpButtonEnd,
                            sideContent: {
                                Button {
                                    viewModel.deleteAllKeywords(context: context)
                                } label: {
                                    Text("전체삭제")
                                        .font(.suitVariable16)
                                }
                                .tint(.black)
                            }, content: {
                                ScrollView (.horizontal, showsIndicators: false) {
                                    HStack (spacing: 0) {
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
                                    .padding(.trailing)
                                }
                            })
                        
                        SpecialSearchContentView(
                            title: "인기 검색어",
                            image: Image(systemName: "flame.fill"),
                            imageColor: .red,
                            sideContent: {
                                if let date = viewModel.whenGetToRecommendedKeywords {
                                    Text("\(formattedTime(date: date)) 갱신")
                                        .font(.suitVariable16)
                                        .foregroundStyle(.gray)
                                }
                            }, content: {
                                ForEach(Array(viewModel.recommendedKeywords.prefix(10).enumerated()), id: \.offset) { index, recommendedKeyword in
                                    HStack {
                                        Button {
                                            viewModel.searchText = recommendedKeyword.searchedWord
                                            viewModel.saveKeyword(viewModel.searchText, context: context)
                                            viewModel.goToSearchResult = true
                                        } label: {
                                            
                                            Text("\(index + 1) ")
                                                .font(.suitBold16)
                                                .foregroundStyle((1...3).contains(index + 1) ? .enrollButton : .black)
                                            
                                            Text(recommendedKeyword.searchedWord)
                                                .font(.suitVariable16)
                                            
                                        }
                                        .tint(.black)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                                }
                            })
                        
                        
                    }
                }
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.searchFocus = false
        }
//        .dragToHide(isHide: $isHideTabBar)
        .onAppear {
            viewModel.recentKeywords = recentKeywords
            viewModel.searchFocus = false
            viewModel.searchFocus = true
            Task {
                await viewModel.getTrendingKeywords()
            }
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
    
    func formattedTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    SearchView(isHideTabBar: .constant(false))
}
