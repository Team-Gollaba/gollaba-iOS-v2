//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""
    @State var searchFocus: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                GeometryReader { geometry in
                        Color.clear
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                searchFocus = false
                            }
                    }
                
                VStack {
                    SearchPollView(text: $searchText, searchFocus: $searchFocus)
                    
                    PollList(title: "🗓️ 오늘의 투표")
                    
                    PollList(title: "🏆 인기 투표")
                    
                    AllPollList()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
