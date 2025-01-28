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
    @State private var viewModel = SearchViewModel()
    @Binding var isHideTabBar: Bool
    
    var body: some View {
        
        ScrollView {
            VStack {
                HStack (spacing: 12) {
                    SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocus) {
                        
                        if viewModel.isValidSearchText() {
                            viewModel.saveKeyword(viewModel.searchText, context: context)
                            viewModel.goToSearchResult = true
                            
                        }
                    }
                    .padding()
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
                            RecentSearchKeywordList(
                                recentSearchKeywords: recentKeywords,
                                tapAction: { keyword in
                                    viewModel.searchText = keyword
                                    viewModel.saveKeyword(viewModel.searchText, context: context)
                                    viewModel.goToSearchResult = true
                                },
                                deleteAction: { keyword in
                                    viewModel.deleteKeyword(keyword, context: context)
                                })
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
                            TrendingKeywordList(
                                trendingKeywords: Array(viewModel.trendingKeywords.prefix(10))) { searchedWord in
                                    viewModel.searchText = searchedWord
                                    viewModel.saveKeyword(viewModel.searchText, context: context)
                                    viewModel.goToSearchResult = true
                                }
                        })
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
            Task {
                await viewModel.getTrendingKeywords()
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                
//                UIApplication.shared.sendAction(
//                    #selector(UIResponder.resignFirstResponder),
//                    to: nil,
//                    from: nil,
//                    for: nil
//                )
//            })
        }
        .onDisappear {
            viewModel.searchFocus = false
        
                viewModel.searchText = ""
        }
        .navigationDestination(isPresented: $viewModel.goToSearchResult, destination: {
            SearchResultListView(searchText: viewModel.searchText)
        })
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
    
    private func formattedTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    SearchView(isHideTabBar: .constant(false))
}
