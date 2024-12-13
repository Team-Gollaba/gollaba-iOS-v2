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
        
        VStack (spacing: 0) {
            ProfileImageView(image: KFImage(kakaoAuthManager.profileImageUrl)) {
                viewModel.isClickedProfileImage = true
            }
            
            ProfileNameView(name: kakaoAuthManager.userName, email: kakaoAuthManager.userMail)
                
            
//            LogoutButton {
//                viewModel.isClickedLogoutButton = true
//            }
            
            TabSwitcherView(tabs: [
                TabSwitcherItem(icon: Image(systemName: "person"), title: "내가 만든 투표", view: AnyView(
                    ScrollView {
                        VerticalPollList(pollList: viewModel.madeByMePollList, requestAddPoll: $viewModel.madeByMePollRequestAdd, isEnd: $viewModel.madeByMePollIsEnd)
                    }
                )),
                TabSwitcherItem(icon: Image(systemName: "heart.fill"), iconColor: .red, title: "내가 좋아요한 투표", view: AnyView(
                    Text("내가 좋아요한 투표")
                ))
            ])

//            GoToMyPollListButton(
//                icon: Image(systemName: "person"),
//                title: "내가 만든 투표",
//                action: {
//                    viewModel.pollListIcon = Image(systemName: "person")
//                    viewModel.pollListTitle = "내가 만든 투표"
//                    viewModel.goToPollList = true
//                }
//            )
//            
//            Divider()
//                .padding(.horizontal)
//            
//            GoToMyPollListButton(
//                icon: Image(systemName: "heart.fill"),
//                title: "내가 좋아요한 투표",
//                action: {
//                    viewModel.pollListIcon = Image(systemName: "heart.fill")
//                    viewModel.pollListTitle = "내가 좋아요한 투표"
//                    viewModel.goToPollList = true
//                }
//            )
            
//            Spacer()
//            
//            if kakaoAuthManager.isLoggedIn {
//                LogoutButton {
//                    viewModel.isClickedLogoutButton = true
//                }
//                .padding(.top)
//            }
        }
        .padding(.top)
        .sheet(isPresented: $viewModel.isClickedProfileImage) {
            ProfileImageDetailView(image: KFImage(kakaoAuthManager.profileImageUrl))
        }
//        .navigationDestination(isPresented: $viewModel.goToPollDetail) {
//            PollDetailView()
//        }
        .navigationDestination(isPresented: $viewModel.goToPollList) {
            if let icon = viewModel.pollListIcon, let title = viewModel.pollListTitle {
                MyPollListView(icon: icon, title: title)
            }
        }
        .dialog(
            isPresented: $viewModel.isClickedLogoutButton,
            title: "로그아웃",
            content: Text("로그아웃 하시겠습니까?"),
            primaryButtonText: "확인",
            secondaryButtonText: "취소",
            onPrimaryButton: {
                kakaoAuthManager.kakaoLogout()
            }
        )
    }
}

#Preview {
    MyPollView()
}
