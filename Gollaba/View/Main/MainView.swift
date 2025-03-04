//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct MainView: View {
    @Environment(PushNotificationManager.self) private var pushNotificationManager
    @Environment(AuthManager.self) private var authManager
    @State var viewModel = MainViewModel.shared
    
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
            .navigationDestination(isPresented: $viewModel.goToDetailView, destination: {
                if let pollHashId = pushNotificationManager.receivedPollHashId {
                    PollDetailView(id: pollHashId)
                } else if let pollHashid = viewModel.pollHashIdFromURL {
                    
                    PollDetailView(id: pollHashid)
                }
            })
            .onChange(of: pushNotificationManager.receivedPollHashId) { _, newValue in
                if newValue != nil {
                    viewModel.goToDetailView = true
                }
            }
            .onOpenURL { url in
                viewModel.handleDeepLink(url)
            }
            .onAppear {
                viewModel.authManager = authManager
                Task {
                    await viewModel.getUserMe()
                }
            }
//            .navigationDestination(
//                isPresented: Binding(
//                    get: { viewModel.pollHashId != nil },
//                    set: { _ in viewModel.pollHashId = nil }
//                )) {
//                    if let pollHashId = viewModel.pollHashId {
//                        PollDetailView(id: pollHashId)
//                    }
//                }
        }
    }
}

#Preview {
    MainView()
}
