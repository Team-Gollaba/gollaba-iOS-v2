//
//  CustomTabView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

enum SelectedTab: Hashable {
    case home
    case search
    case create
    case myPoll
}

struct CustomTabView: View {
    @State private var selectedTab: SelectedTab = .home
    @State private var isScrollToTop: Bool = false
    @State private var isHideTabBar: Bool = false
    
    let tabBarHeight: CGFloat = 60
    @State var safeAreaBottom: CGFloat = 0
    
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(scrollToTopTrigger: $isScrollToTop, isHideTapBar: $isHideTabBar)
                    .tag(SelectedTab.home)
                
                SearchView(isHideTabBar: $isHideTabBar)
                    .tag(SelectedTab.search)
                
                CreatePollView(isHideTabBar: $isHideTabBar)
                    .tag(SelectedTab.create)
                
                MyPollView(isHideTabBar: $isHideTabBar)
                    .tag(SelectedTab.myPoll)
                
            }
//            .padding(.bottom, tabBarHeight)
            .padding(.bottom, isHideTabBar ? 0 : tabBarHeight)
//            .animation(.easeInOut(duration: 0.3), value: isHideTabBar)
            
            
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
                        selectedTab = .search
                    },
                    image: Image(systemName: selectedTab == .search ?  "magnifyingglass.circle.fill" : "magnifyingglass.circle"),
                    title: "검색",
                    isSelected: selectedTab == .search
                )
                .tint(selectedTab == .search ? .black : .gray)
                
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
            .offset(y: isHideTabBar ? tabBarHeight + safeAreaBottom : 0)
        }
        .animation(.easeIn(duration: 0.3), value: isHideTabBar)
        .onAppear {
            if safeAreaBottom == 0 {
                print("safeAreaBottom: \(safeAreaBottom)")
                safeAreaBottom = getSafeAreaInsets()?.bottom ?? 0
            }
        }
    }
    
    private func getSafeAreaInsets() -> UIEdgeInsets? {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else {
            return nil
        }
        return window.safeAreaInsets
    }
}

#Preview {
    CustomTabView()
}
