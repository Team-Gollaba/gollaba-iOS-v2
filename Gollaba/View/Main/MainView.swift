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
            ZStack (alignment: .top) {
                
                CustomTabView()
                    .padding(.top, 60)
                
                TitleView(goToLogin: $viewModel.goToLogin)
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
