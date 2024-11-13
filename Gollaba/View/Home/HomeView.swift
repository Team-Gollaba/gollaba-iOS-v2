//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                PollList(title: "🗓️ 오늘의 투표")
                    
                PollList(title: "🏆 인기 투표")
                
                AllPollList()
            }
        }
    }
}

#Preview {
    HomeView()
}
