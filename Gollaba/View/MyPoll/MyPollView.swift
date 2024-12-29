//
//  MyPollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI
import Kingfisher

struct MyPollView: View {
    @Environment(AuthManager.self) var authManager
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
        
        ZStack {
                ScrollView {
                    if authManager.isLoggedIn {
                        VStack (spacing: 0) {
                            ProfileImageView(image: authManager.isLoggedIn ? KFImage(authManager.kakaoAuthManager.profileImageUrl) : nil) {
                                viewModel.isClickedProfileImage = true
                            }
                            
                            ProfileNameView(name: authManager.isLoggedIn ? authManager.kakaoAuthManager.userName : "유저", email: authManager.isLoggedIn ? authManager.kakaoAuthManager.userMail : "")
                                .padding(.bottom, 12)
                            
                            
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
                            
                            LogoutButton {
                                viewModel.isClickedLogoutButton = true
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
                            ProfileImageDetailView(image: KFImage(authManager.kakaoAuthManager.profileImageUrl))
                        }
                        //        .navigationDestination(isPresented: $viewModel.goToPollDetail) {
                        //            PollDetailView()
                        //        }
                        .navigationDestination(isPresented: $viewModel.goToPollList) {
                            if let icon = viewModel.pollListIcon, let title = viewModel.pollListTitle {
                                MyPollListView(icon: icon, title: title)
                            }
                        }
                    } else {
                        VStack (spacing: 20) {
                            Spacer()
                            
                            Text("모든 기능을 이용하려면\n로그인을 해주세요.")
                                .font(.yangjin32)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            
                            InduceLoginContentView(
                                icon: Image(systemName: "chart.bar"),
                                iconColor: .signUpButtonStart,
                                iconBackgroundColor: .signUpButtonStart.opacity(0.1),
                                title: "생성한 투표 보기",
                                subtitle: "실시간으로 생성한 모든 투표를 확인하세요.".forceCharWrapping
                            )
                            
                            InduceLoginContentView(
                                icon: Image(systemName: "suit.heart"),
                                iconColor: .red,
                                iconBackgroundColor: .red.opacity(0.1),
                                title: "좋아요한 투표 목록",
                                subtitle: "좋아요를 누른 투표를 저장하고 언제든지 다시 확인하세요.".forceCharWrapping
                            )
                            
                            InduceLoginContentView(
                                icon: Image(systemName: "person"),
                                iconColor: .signUpButtonStart,
                                iconBackgroundColor: .signUpButtonStart.opacity(0.1),
                                title: "개인 프로필",
                                subtitle: "고유한 프로필을 만들고 투표 평판을 쌓아보세요.".forceCharWrapping
                            )
                            
                            Button {
                                viewModel.goToLogin = true
                            } label: {
                                HStack {
                                    Text("로그인")
                                        .font(.suitBold16)
                                    
                                    Image(systemName: "arrow.right")
                                }
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.signUpButtonEnd)
                                )
                            }
                            
                            Spacer()
                        }
                        .padding(40)
                        .navigationDestination(isPresented: $viewModel.goToLogin) {
                            LoginView()
                        }
                    }
                    
                }
                .dialog(
                    isPresented: $viewModel.isClickedLogoutButton,
                    title: "로그아웃",
                    content: Text("로그아웃 하시겠습니까?"),
                    primaryButtonText: "확인",
                    secondaryButtonText: "취소",
                    onPrimaryButton: {
                        Task {
                            await viewModel.kakaoLogout()
                        }
                    }
                )
            
            
        }
        .onAppear {
            viewModel.authManager = authManager
        }
    }
}

#Preview {
    MyPollView(isHideTabBar: .constant(false))
}
