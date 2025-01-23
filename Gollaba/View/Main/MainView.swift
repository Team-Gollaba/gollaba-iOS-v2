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
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                
                TitleView(goToLogin: $viewModel.goToLogin, height: titleViewHeight)
                
            }
            .navigationDestination(isPresented: $viewModel.goToLogin) {
                LoginView()
            }
            .onAppear {
                Task {
                    do {
                        let token = try await ApiManager.shared.refreshToken()
                        Logger.shared.log(String(describing: self), #function, "Success to refresh token: \(token)")
                    } catch {
                        Logger.shared.log(String(describing: self), #function, "Failed to refresh token", .error)
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
