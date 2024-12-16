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
                        
                        VerticalPollList(
                            pollList: items,
                            requestAddPoll: $viewModel.requestAddPoll,
                            isEnd: $viewModel.isEnd
                        )
                        .onChange(of: viewModel.requestAddPoll) { _, newValue in
                            
                            if newValue && viewModel.page != 1 {
                                Task {
                                    await viewModel.fetchMoreResult()
                                }
                            }
                        }
                        
                    }
                }
                
                Spacer()
            }
            
            if viewModel.isFilterOpen {
                SearchFilterView(
                    isFilterOpen: $viewModel.isFilterOpen,
                    madeDateFilter: $viewModel.madeDateFilter,
                    pollTypeFilter: $viewModel.pollTypeFilter,
                    isActiveFilter: $viewModel.isActiveFilter
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
    SearchView()
}
