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
    
    var body: some View {
        VStack {
            ZStack {
                if selectedTab == .home {
                    HomeView()
                } else if selectedTab == .create {
                    CreatePollView()
                } else if selectedTab == .myPoll {
                    MyPollView()
                }
            }
            .frame(maxHeight: .infinity)
            
            ZStack {
                
                
                HStack {
                    CustomTabViewButton(
                        action: {
                            selectedTab = .home
                        },
                        image: Image(systemName: "house.fill"),
                        title: "홈"
                    )
                    .tint(selectedTab == .home ? .black : .gray)
                    
                    CustomTabViewButton(
                        action: {
                            selectedTab = .create
                        },
                        image: Image(systemName: "plus.circle.fill"),
                        title: "새 투표"
                    )
                    .tint(selectedTab == .create ? .black : .gray)
                    
                    CustomTabViewButton(
                        action: {
                            selectedTab = .myPoll
                        },
                        image: Image(systemName: "folder.fill"),
                        title: "My 투표"
                    )
                    .tint(selectedTab == .myPoll ? .black : .gray)
                }
                .frame(height: 100)
                .background(.white)
                .background(
                    Rectangle()
                        .background(.white)
                        .shadow(radius: 5)
                )
            }
            
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    CustomTabView()
}
