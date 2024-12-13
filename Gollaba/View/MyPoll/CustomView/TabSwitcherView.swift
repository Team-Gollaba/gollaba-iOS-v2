//
//  TabSwitcherView.swift
//  Gollaba
//
//  Created by 김견 on 12/13/24.
//

import SwiftUI

struct TabSwitcherItem {
    let icon: Image
    var iconColor: Color?
    let title: String
    let view: AnyView
}

struct TabSwitcherView: View {
    @State private var selectedTab: Int = 0
    let tabs: [TabSwitcherItem]
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    Button {
                        withAnimation {
                            selectedTab = index
                        }
                    } label: {
                        VStack (alignment: .center) {
                            HStack {
                                tab.icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(tab.iconColor ?? .black)
                                
                                Text(tab.title)
                                    .font(.yangjin16)
                            }
                            
                            Rectangle()
                                .fill(selectedTab == index ? .enrollButton : .clear)
                                .frame(maxWidth: .infinity)
                                .frame(height: 2)
                                .animation(.easeInOut, value: selectedTab)
                        }
                    }
                    .tint(.black)
                }
            }
            .padding(.horizontal)
            
            TabView(selection: $selectedTab) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    tab.view
                        .tag(index)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
//            .tabViewStyle(.page)
//            .animation(.easeInOut, value: selectedTab)
        }
    }
}
//
//#Preview {
//    TabSwitcherView(tabs: [TabSwitcherItem(icon: Image(systemName: "person"), title: "title", view: Text("content"))])
//}
