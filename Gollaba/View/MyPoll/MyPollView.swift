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
            VStack (spacing: 12) {
                
                ProfileImageView(image: Image("cha_eun_woo"))
                
                ProfileNameView(name: "Cha eunwoo")
                
                MyLikePollsCountView(countLikePolls: 42, action: {
                    
                })
                
                VerticalPollList(
                    goToPollDetail: $viewModel.goToPollDetail,
                    icon: Image(systemName: "person"),
                    title: "내가 만든 투표"
                )
                
                LogoutButton {
                    
                }
            }
            .padding(.vertical)
        }
        .navigationDestination(isPresented: $viewModel.goToPollDetail) {
            PollDetailView()
        }
    }
}

#Preview {
    MyPollView()
}
