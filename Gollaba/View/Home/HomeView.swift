//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @Binding var scrollToTopTrigger: Bool
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { parentScrollProxy in
                ScrollView {
                    ZStack {
                        GeometryReader { geometry in
                            Color.clear
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.searchFocus = false
                                }
                        }
                        
                        VStack {
                            Color.clear
                                .frame(height: 0)
                                .id("Top")
                            
                            SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocus) {
                                if viewModel.isValidSearchText() {
                                    
                                }
                            }
                            
                            HorizontalPollList(
                                title: "🗓️ 오늘의 투표",
                                pollList: (viewModel.trendingPolls?.isEmpty ?? true) ? viewModel.tempPolls : viewModel.trendingPolls!,
                                isScrollToLeading: $viewModel.isScrollToTop,
                                goToPollDetail: $viewModel.goToPollDetail
                            )
                            
                            
                            
                            HorizontalPollList(
                                title: "🏆 인기 투표",
                                pollList: (viewModel.topPolls?.isEmpty ?? true) ? viewModel.tempPolls : viewModel.topPolls!,
                                isScrollToLeading: $viewModel.isScrollToTop,
                                goToPollDetail: $viewModel.goToPollDetail
                            )
                            
                            
                            
                            VerticalPollList(
                                title: "📝 전체 투표",
                                pollList: (viewModel.allPolls?.items.isEmpty ?? true) ? viewModel.tempPolls : viewModel.allPolls!.items,
                                requestAddPoll: $viewModel.requestAddPoll,
                                isEnd: $viewModel.isAllPollsEnd
                            )
                            .onChange(of: viewModel.requestAddPoll) { _, newValue in
                                if newValue {
                                    viewModel.fetchPolls()
                                }
                            }
                            
                        }
                        .onChange(of: scrollToTopTrigger) { _, newValue in
                            if newValue {
                                scrollToTopTrigger = false
                                withAnimation {
                                    parentScrollProxy.scrollTo("Top", anchor: .top)
                                }
                            }
                        }
                    }
                }
                .refreshable(action: viewModel.loadEveryPolls)
                .onAppear {
                    viewModel.getPolls()
                    viewModel.getTrendingPolls()
                    viewModel.getTopPolls()
                }
            }
        }
        .toast(
            isPresenting: $viewModel.showSearchErrorToast) {
                AlertToast(type: .error(.red), title: "검색할 키워드를 입력해주세요.", style: .style(titleFont: .suitBold16))
            }
    }
}

#Preview {
    HomeView(scrollToTopTrigger: .constant(false))
}
