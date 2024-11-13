//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct MainView: View {
    @State var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TitleView(goToLogin: $viewModel.goToLogin)
                
                CustomTabView()
                
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
