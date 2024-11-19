//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
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
                        SearchPollView(text: $viewModel.searchText, searchFocus: $viewModel.searchFocus)
                        
                        HorizontalPollList(title: "🗓️ 오늘의 투표", goToPollDetail: $viewModel.goToPollDetail)
                        
                        HorizontalPollList(title: "🏆 인기 투표", goToPollDetail: $viewModel.goToPollDetail)
                        
                        VerticalPollList(goToPollDetail: $viewModel.goToPollDetail, title: "📝 전체 투표")
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.goToPollDetail) {
                PollDetailView()
            }
        }
    }
}

#Preview {
    HomeView()
}
