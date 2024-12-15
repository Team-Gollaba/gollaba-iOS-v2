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
        GeometryReader { geometry in
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
                    .frame(width: geometry.size.width / CGFloat(tabs.count) - 100, height: 4)
                    .offset(x: geometry.size.width * (CGFloat(selectedTab) - CGFloat(tabs.count - 1) / 2) / CGFloat(tabs.count))
                    .animation(.bouncy, value: selectedTab)
                    .padding(.top, 12)
                
                TabView(selection: $selectedTab) {
                    ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                        tab.view
                            .tag(index)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: selectedTab)
            }
        }
    }
}
//
//#Preview {
//    TabSwitcherView(tabs: [TabSwitcherItem(icon: Image(systemName: "person"), title: "title", view: Text("content"))])
//}
