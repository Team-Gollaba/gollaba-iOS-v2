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
    let itemCount: Int
    let view: AnyView
}

struct TabSwitcherView: View {
    @State private var selectedTab: Int = 0
    let tabs: [TabSwitcherItem]
    
    var body: some View {
            VStack (spacing: 0) {
                HStack (alignment: .center) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        Button {
//                            withAnimation {
                                selectedTab = index
//                            }
                        } label: {
                            VStack (alignment: .center) {
                                HStack {
//                                    tab.icon
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 16, height: 16)
//                                        .foregroundStyle(tab.iconColor ?? .black)
                                    
                                    Text(tab.title)
                                        .font(.yangjin16)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .tint(.black)
                    }
                }
//                .padding(.horizontal)
                
                Rectangle()
                    .fill(.enrollButton)
                    .frame(width: UIScreen.main.bounds.width / CGFloat(tabs.count) - 100, height: 4)
                    .offset(x: UIScreen.main.bounds.width / CGFloat(tabs.count) * (CGFloat(selectedTab) - (CGFloat(tabs.count - 1) / 2)))

                    .animation(.bouncy, value: selectedTab)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                
                TabView(selection: $selectedTab) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        tab.view
                            .tag(index)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: max(UIScreen.main.bounds.height - 400, CGFloat(tabs[selectedTab].itemCount) * 100))
                .animation(.easeInOut, value: selectedTab)
            }
        
    }
}
//
//#Preview {
//    TabSwitcherView(tabs: [TabSwitcherItem(icon: Image(systemName: "person"), title: "title", view: Text("content"))])
//}
