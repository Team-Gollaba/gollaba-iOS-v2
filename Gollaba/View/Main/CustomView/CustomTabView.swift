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
    @State private var moveToHome: Bool = false
    
    let tabBarHeight: CGFloat = 60
    
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(scrollToTopTrigger: $isScrollToTop, movedToHome: $moveToHome)
                    .tag(SelectedTab.home)
                
                CreatePollView(moveToHome: $moveToHome)
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
                    image: Image(systemName: selectedTab == .home ?  "house.fill" : "house"),
                    title: "홈",
                    isSelected: selectedTab == .home
                )
                .tint(selectedTab == .home ? .black : .gray)
                
                CustomTabViewButton(
                    action: {
                        selectedTab = .create
                    },
                    image: Image(systemName: selectedTab == .create ? "plus.circle.fill" : "plus.circle"),
                    title: "새 투표",
                    isSelected: selectedTab == .create
                )
                .tint(selectedTab == .create ? .black : .gray)
                
                CustomTabViewButton(
                    action: {
                        selectedTab = .myPoll
                    },
                    image: Image(systemName: selectedTab == .myPoll ? "person.circle.fill" : "person.circle"),
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
        .onChange(of: moveToHome) { _, newValue in
            if newValue {
                selectedTab = .home
                moveToHome = false
            }
        }
    }
}

#Preview {
    CustomTabView()
}
