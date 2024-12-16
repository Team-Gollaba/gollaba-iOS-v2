//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct MainView: View {
    @State var viewModel = MainViewModel()
    
    let titleViewHeight: CGFloat = 48
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .top) {
                
                CustomTabView()
                    .padding(.top, titleViewHeight)
                
                TitleView(goToLogin: $viewModel.goToLogin, height: titleViewHeight)
                
            }
            .navigationDestination(isPresented: $viewModel.goToLogin) {
                LoginView()
            }
        }
    }
}

#Preview {
    MainView()
}
