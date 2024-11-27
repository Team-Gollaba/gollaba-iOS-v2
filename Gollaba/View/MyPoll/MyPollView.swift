//
//  MyPollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI
import Kingfisher

struct MyPollView: View {
    @Environment(KakaoAuthManager.self) var kakaoAuthManager
    @State var viewModel = MyPollViewModel()
    
    var body: some View {
        ZStack {
            if kakaoAuthManager.isLoggedIn {
                VStack {
                    
                    ProfileImageView(image: KFImage(kakaoAuthManager.profileImageUrl)) {
                        viewModel.isClickedProfileImage = true
                    }
                    
                    ProfileNameView(name: kakaoAuthManager.userName, email: kakaoAuthManager.userMail)
                        .padding(.bottom, 16)
                    
                    //                    MyLikePollsCountView(countLikePolls: 42, action: {
                    //
                    //                    })
                    
                    
                    GoToMyPollListButton(
                        icon: Image(systemName: "person"),
                        title: "내가 만든 투표",
                        action: {
                            viewModel.pollListIcon = Image(systemName: "person")
                            viewModel.pollListTitle = "내가 만든 투표"
                            viewModel.goToPollList = true
                        }
                    )
                    
                    Divider()
                        .padding(.horizontal)
                    
                    GoToMyPollListButton(
                        icon: Image(systemName: "heart.fill"),
                        title: "내가 좋아요한 투표",
                        action: {
                            viewModel.pollListIcon = Image(systemName: "heart.fill")
                            viewModel.pollListTitle = "내가 좋아요한 투표"
                            viewModel.goToPollList = true
                        }
                    )
                    
                    Spacer()
                    
                    LogoutButton {
                        
                    }
                    .padding(.top)
                }
                .padding(.vertical)
                .sheet(isPresented: $viewModel.isClickedProfileImage) {
                    ProfileImageDetailView(image: KFImage(kakaoAuthManager.profileImageUrl))
                }
                .navigationDestination(isPresented: $viewModel.goToPollDetail) {
                    PollDetailView()
                }
                .navigationDestination(isPresented: $viewModel.goToPollList) {
                    if let icon = viewModel.pollListIcon, let title = viewModel.pollListTitle {
                        MyPollListView(icon: icon, title: title)
                    }
                }
            } else {
                Text("로그인 후 이용해주세요.")
                    .font(.suitBold32)
            }
        }
        
        
        
    }
}

#Preview {
    MyPollView()
}
