//
//  CustomTabView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

enum SelectedTab: Hashable {
    case home
    case create
    case myPoll
}

struct CustomTabView: View {
    @State private var selectedTab: SelectedTab = .home
    @State private var isScrollToTop: Bool = false
    
    let tabBarHeight: CGFloat = 80
    
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(scrollToTopTrigger: $isScrollToTop)
                    .tag(SelectedTab.home)
                
                CreatePollView()
                    .tag(SelectedTab.create)
                    
                
                MyPollView()
                    .tag(SelectedTab.myPoll)
                    
            }
            .padding(.bottom, tabBarHeight)
            
            
            HStack {
                CustomTabViewButton(
                    action: {
                        if selectedTab == .home {
                            isScrollToTop = true
                        }
                        selectedTab = .home
                    },
                    image: Image(systemName: "house.fill"),
                    title: "홈",
                    isSelected: selectedTab == .home
                )
                .tint(selectedTab == .home ? .black : .gray)
                
                CustomTabViewButton(
                    action: {
                        selectedTab = .create
                    },
                    image: Image(systemName: "plus.circle.fill"),
                    title: "새 투표",
                    isSelected: selectedTab == .create
                )
                .tint(selectedTab == .create ? .black : .gray)
                
                CustomTabViewButton(
                    action: {
                        selectedTab = .myPoll
                    },
                    image: Image(systemName: "folder.fill"),
                    title: "My 투표",
                    isSelected: selectedTab == .myPoll
                )
                .tint(selectedTab == .myPoll ? .black : .gray)
            }
            .frame(height: tabBarHeight)
            .background(.white)
            .background(
                Rectangle()
                    .background(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 3)
            )
        }
    }
}

#Preview {
    CustomTabView()
}
