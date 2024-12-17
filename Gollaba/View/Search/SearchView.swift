//
//  SearchView.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import SwiftUI
import AlertToast

struct SearchView: View {
    @State var viewModel = SearchViewModel()
    @Binding var isHideTabBar: Bool
    
    var body: some View {
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
                HStack (spacing: 12) {
                    SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocus) {
                        viewModel.searchFocus = false
                        if viewModel.isValidSearchText() {
                            Task {
                                await viewModel.getPolls()
                            }
                        }
                    }
                    
                    SearchFilterButton(isFilterOpen: $viewModel.isFilterOpen)
                        .padding(.leading, -12)
                }
                
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
                                
                                if newValue && viewModel.page != 0 {
                                    Task {
                                        await viewModel.fetchMoreResult()
                                    }
                                }
                            }
                        }
                    }
                    .dragToHide(isHide: $isHideTabBar)
                } else {
                    Spacer()
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
                                await viewModel.getPolls()
                            }
                        }
                    }
                )
            }
        }
        .toast(
            isPresenting: $viewModel.showSearchErrorToast) {
                AlertToast(type: .error(.red), title: "검색할 키워드를 입력해주세요.", style: .style(titleFont: .suitBold16))
            }
    }
}

#Preview {
    SearchView(isHideTabBar: .constant(false))
}
