//
//  MyPollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct MyPollView: View {
    @State var viewModel = MyPollViewModel()
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack (spacing: 12) {
                    
                    ProfileImageView(image: Image("cha_eun_woo")) {
                        viewModel.isClickedProfileImage = true
                    }
                    
                    ProfileNameView(name: "Cha eunwoo")
                    
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
                        icon: Image(systemName: "heart"),
                        title: "내가 좋아요한 투표",
                        action: {
                            viewModel.pollListIcon = Image(systemName: "heart")
                            viewModel.pollListTitle = "내가 좋아요한 투표"
                            viewModel.goToPollList = true
                        }
                    )
                    
//                    VerticalPollList(
//                        goToPollDetail: $viewModel.goToPollDetail,
//                        icon: Image(systemName: "person"),
//                        title: "내가 만든 투표"
//                    )
                    
                    LogoutButton {
                        
                    }
                    .padding(.top)
                }
                .padding(.vertical)
                
                
            }
            .sheet(isPresented: $viewModel.isClickedProfileImage) {
                ProfileImageDetailView(image: Image("cha_eun_woo"))
            }
        }
        .navigationDestination(isPresented: $viewModel.goToPollDetail) {
            PollDetailView()
        }
        .navigationDestination(isPresented: $viewModel.goToPollList) {
            if let icon = viewModel.pollListIcon, let title = viewModel.pollListTitle {
                MyPollListView(icon: icon, title: title)
            }
        }
    }
}

#Preview {
    MyPollView()
}
