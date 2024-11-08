//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct HomeView: View {
    @State var tabIndex: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Image("AppIconImage")
                    .resizable()
                    .frame(width: 60, height: 60)
                
                Text("골라바")
                    .font(.yangjin30)
                    .underline(color: .titleFontColor)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("로그인")
                        .font(.suit_variable16)
                        .foregroundStyle(.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .padding(.horizontal)
            .background(Color.toolbarBackgroundColor)
            
            TabView(selection: $tabIndex) {
                Text("홈")
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)
                
                Text("만들기")
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tag(0)
                
                Text("내 투표")
                    .tabItem {
                        Image(systemName: "folder.fill")
                    }
                    .tag(0)
            }
            .tint(.black)
        }
    }
}

#Preview {
    HomeView()
}
