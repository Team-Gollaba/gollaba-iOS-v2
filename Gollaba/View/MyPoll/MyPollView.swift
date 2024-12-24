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
    @Binding var isHideTabBar: Bool
    
    struct MadeByMeTabHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue()) // 여러 값 중 최대값을 사용
        }
    }
    
    struct LikeTabHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue()) // 여러 값 중 최대값을 사용
        }
    }
    
    var body: some View {
        
        ScrollView {
            VStack (spacing: 0) {
                ProfileImageView(image: KFImage(kakaoAuthManager.profileImageUrl)) {
                    viewModel.isClickedProfileImage = true
                }
                
                ProfileNameView(name: kakaoAuthManager.userName, email: kakaoAuthManager.userMail)
                    .padding(.bottom, 12)
                
                
                //            LogoutButton {
                //                viewModel.isClickedLogoutButton = true
                //            }
                
                HStack {
                    Button {
                        viewModel.selectedTab = .madeByMe
                    } label: {
                        Text("내가 만든 투표")
                            .font(.yangjin16)
                    }
                    .tint(.black)
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.selectedTab = .like
                    } label: {
                        Text("내가 좋아하는 투표")
                            .font(.yangjin16)
                    }
                    .tint(.black)
                    .frame(maxWidth: .infinity)
                }
                
                Rectangle()
                    .fill(.enrollButton)
                    .frame(width: UIScreen.main.bounds.width / 2 - 100, height: 4)
                    .offset(x: UIScreen.main.bounds.width / 2 * (CGFloat(viewModel.selectedTab.rawValue) - (1 / 2)))
                    .animation(.bouncy, value: viewModel.selectedTab)
                
                TabView (selection: $viewModel.selectedTab) {
                    PollMadeByMeListView(pollMadeByMeList: viewModel.madeByMePollList)
                        .tag(MyPollSelectedTab.madeByMe)
                        .background(GeometryReader { proxy in
                            Color.clear
                                .preference(key: MadeByMeTabHeightPreferenceKey.self, value: proxy.size.height) // 크기 추적
                        })
                    
                    Text("내가 좋아하는 투표")
                        .frame(height: 400)
                        .tag(MyPollSelectedTab.like)
                        .background(GeometryReader { proxy in
                            Color.clear
                                .preference(key: LikeTabHeightPreferenceKey.self, value: proxy.size.height) // 크기 추적
                        })
                }
                .frame(height: viewModel.currentTabHeight) // 현재 선택된 탭의 높이만 사용
                .onPreferenceChange(MadeByMeTabHeightPreferenceKey.self) { value in
                    viewModel.madeByMeTabHeight = value // 각 탭의 높이를 저장
                    viewModel.updateCurrentTabHeight() // 현재 탭 높이 업데이트
                }
                .onPreferenceChange(LikeTabHeightPreferenceKey.self) { value in
                    viewModel.likeTabHeight = value // 각 탭의 높이를 저장
                    viewModel.updateCurrentTabHeight() // 현재 탭 높이 업데이트
                }
                .onChange(of: viewModel.selectedTab) {
                    DispatchQueue.main.async {
                        withTransaction(Transaction(animation: nil)) {
                            viewModel.updateCurrentTabHeight()
                        }
                    }
                }
                
                //                TabSwitcherView(tabs: [
                //                    TabSwitcherItem(icon: Image(systemName: "person"), title: "내가 만든 투표", itemCount: viewModel.madeByMePollList.count, view: AnyView(
                //                        GeometryReader { proxy in
                //
                //                            VStack (spacing: 0) {
                //
                //                                ForEach(viewModel.madeByMePollList, id: \.self) { poll in
                //
                //                                    PollMadeByMeView(poll: poll)
                //
                //                                }
                //                            }
                //
                //
                //                            .dragToHide(isHide: $isHideTabBar)
                //                        }
                //                    )),
                //                    TabSwitcherItem(icon: Image(systemName: "heart.fill"), iconColor: .red, title: "내가 좋아요한 투표", itemCount: 1, view: AnyView(
                //                        Text("내가 좋아요한 투표")
                //                    ))
                //                ])
                
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
            .ignoresSafeArea(.all)
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
}

#Preview {
    MyPollView(isHideTabBar: .constant(false))
}
