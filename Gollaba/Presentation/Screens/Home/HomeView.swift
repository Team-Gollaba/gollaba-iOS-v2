//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var dragStartLocation: CGFloat = 0.0
    @State private var dragEndLocation: CGFloat = 0.0
    @Binding var scrollToTopTrigger: Bool
    @Binding var isHideTapBar: Bool
    @Binding var goToSearch: Bool
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { parentScrollProxy in
                ScrollView {
                    VStack {
                        Color.clear
                            .frame(height: 0)
                            .id("Top")
                        
                        GoToSearchView {
                            goToSearch = true
                        }
                        
                        HomeDividerView()
                        
                        HorizontalPollList(
                            title: "🗓️ 오늘의 투표",
                            pollList: viewModel.trendingPolls == nil ? PollItem.tempDataList() : viewModel.trendingPolls!,
                            isScrollToLeading: $viewModel.isScrollToTop
                        )
                        
                        HomeDividerView()
                        
                        HorizontalPollList(
                            title: "🏆 인기 투표",
                            pollList: viewModel.topPolls == nil ? PollItem.tempDataList() : viewModel.topPolls!,
                            isScrollToLeading: $viewModel.isScrollToTop
                        )
                        
                        HomeDividerView()
                        
                        VerticalPollList(
                            title: "📝 전체 투표",
                            pollList: viewModel.allPolls == nil ? [PollItem.mockData()] : viewModel.allPolls!.items,
                            requestAddPoll: $viewModel.requestAddPoll,
                            isEnd: $viewModel.isAllPollsEnd
                        )
                        .onChange(of: viewModel.requestAddPoll) { _, newValue in
                            if newValue {
                                Task {
                                    await viewModel.fetchPolls()
                                }
                            }
                        }
                        
                    }
                    .onChange(of: scrollToTopTrigger) { _, newValue in
                        if newValue {
                            scrollToTopTrigger = false
                            withAnimation {
                                parentScrollProxy.scrollTo("Top", anchor: .bottom)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                }
                .refreshable(action: viewModel.loadEveryPolls)
                .onAppear {
                    Task {
                        await viewModel.getPolls()
                        await viewModel.getTrendingPolls()
                        await viewModel.getTopPolls()
                    }
                }
                .dragToHide(isHide: $isHideTapBar)
                .dialog(
                    isPresented: $viewModel.showErrorDialog,
                    title: "홈 화면",
                    content: Text("\(viewModel.errorMessage)")
                )
            }
        }
    }
}

#Preview {
    HomeView(scrollToTopTrigger: .constant(false), isHideTapBar: .constant(false), goToSearch: .constant(false))
}
