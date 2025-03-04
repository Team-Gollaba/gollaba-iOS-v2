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
    @State private var isHomeViewScrollToTop: Bool = false
    @State private var isMyPollViewScrollToTop: Bool = false
    @State private var isHideTabBar: Bool = false
    
    @State private var goToSearch: Bool = false
    
    let tabBarHeight: CGFloat = 40
    @State var safeAreaBottom: CGFloat = 0
    
    var body: some View {
        ZStack (alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(scrollToTopTrigger: $isHomeViewScrollToTop, isHideTapBar: $isHideTabBar, goToSearch: $goToSearch)
                    .tag(SelectedTab.home)
                
                SearchView(isHideTabBar: $isHideTabBar)
                    .tag(SelectedTab.search)
                
                CreatePollView(isHideTabBar: $isHideTabBar)
                    .tag(SelectedTab.create)
                
                MyPollView(scrollToTopTrigger: $isMyPollViewScrollToTop, isHideTabBar: $isHideTabBar)
                    .tag(SelectedTab.myPoll)
                
            }
            .padding(.bottom, isHideTabBar ? 0 : tabBarHeight)
            .animation(.bouncy, value: isHideTabBar)

            
            
            HStack {
                CustomTabViewButton(
                    action: {
                        if selectedTab == .home {
                            isHomeViewScrollToTop = true
                        }
                        selectedTab = .home
                    },
                    image: Image(systemName: selectedTab == .home ?  "house.fill" : "house"),
                    title: "홈",
                    isSelected: selectedTab == .home
                )
                
                CustomTabViewButton(
                    action: {
                        selectedTab = .search
                    },
                    image: Image(systemName: selectedTab == .search ?  "magnifyingglass.circle.fill" : "magnifyingglass.circle"),
                    title: "검색",
                    isSelected: selectedTab == .search
                )
                
                CustomTabViewButton(
                    action: {
                        selectedTab = .create
                    },
                    image: Image(systemName: selectedTab == .create ? "plus.circle.fill" : "plus.circle"),
                    title: "새 투표",
                    isSelected: selectedTab == .create
                )
                
                CustomTabViewButton(
                    action: {
                        if selectedTab == .myPoll {
                            isMyPollViewScrollToTop = true
                        }
                        selectedTab = .myPoll
                    },
                    image: Image(systemName: selectedTab == .myPoll ? "person.circle.fill" : "person.circle"),
                    title: "My 투표",
                    isSelected: selectedTab == .myPoll
                )
            }
            .frame(height: tabBarHeight)
            .background(.white)
            .background(
                Rectangle()
                    .background(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 3)
            )
            .offset(y: isHideTabBar ? tabBarHeight + safeAreaBottom : 0)
            .animation(.bouncy, value: isHideTabBar)
        }
//        .animation(.easeIn(duration: 0.3), value: isHideTabBar)
        .onAppear {
            if safeAreaBottom == 0 {
                safeAreaBottom = getSafeAreaInsets()?.bottom ?? 0
            }
        }
        .onChange(of: goToSearch) { _, newValue in
            if newValue {
                selectedTab = .search
                goToSearch = false
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
