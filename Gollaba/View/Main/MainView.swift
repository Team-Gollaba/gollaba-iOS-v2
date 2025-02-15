//
//  HomeView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct MainView: View {
    @Environment(PushNotificationManager.self) private var pushNotificationManager
    @State var viewModel = MainViewModel.shared
    @State private var goToDetailView: Bool = false
    
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
            .navigationDestination(isPresented: $goToDetailView, destination: {
                if let pollHashId = pushNotificationManager.receivedPollHashId {
                    PollDetailView(id: pollHashId)
                }
            })
            .onChange(of: pushNotificationManager.receivedPollHashId) { _, newValue in
                if newValue != nil {
                    goToDetailView = true
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
