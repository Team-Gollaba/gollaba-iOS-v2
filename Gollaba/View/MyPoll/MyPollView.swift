//
//  MyPollView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI
import Kingfisher

struct MyPollView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = MyPollViewModel()
    @Binding var scrollToTopTrigger: Bool
    @Binding var isHideTabBar: Bool
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    
    struct MadeByMeTabHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue()) // 여러 값 중 최대값을 사용
        }
    }
    
    struct FavoriteByMeTabHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue()) // 여러 값 중 최대값을 사용
        }
    }
    
    struct ParticipatedTabHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue()) // 여러 값 중 최대값을 사용
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if authManager.isLoggedIn {
                ScrollViewReader { parentScrollProxy in
                    ScrollView {
                        VStack (spacing: 0) {
                            Color.clear
                                .frame(height: 0)
                                .id("Top")
                            
                            ProfileImageView(
                                imageUrl: authManager.userData?.profileImageUrl,
                                width: 100,
                                height: 100
                            ) {
                                viewModel.isClickedProfileImage = true
                            }
                            
                            Text(viewModel.name)
                                .font(.suitBold20)
                                .padding(.top, 12)
                                .padding(.bottom, 24)
                            
                            
                            HStack {
                                Button {
                                    viewModel.selectedTab = .createdByMe
                                } label: {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(viewModel.selectedTab == .createdByMe ? .enrollButton : .gray)
                                }
                                .tint(.black)
                                .frame(maxWidth: .infinity)
                                
                                Button {
                                    viewModel.selectedTab = .faovirteByMe
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(viewModel.selectedTab == .faovirteByMe ? .enrollButton : .gray)
                                }
                                .tint(.black)
                                .frame(maxWidth: .infinity)
                                
                                Button {
                                    viewModel.selectedTab = .participated
                                } label: {
                                    Image(systemName: "checkmark.square.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(viewModel.selectedTab == .participated ? .enrollButton : .gray)
                                }
                                .tint(.black)
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.bottom, 8)
                            
                            Rectangle()
                                .fill(.enrollButton)
                                .frame(width: UIScreen.main.bounds.width / 3 - 24, height: 4) // 3등분 중 여백 포함
                                .offset(x: (UIScreen.main.bounds.width / 3) * CGFloat(viewModel.selectedTab.rawValue) - UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width / 6)
                                .animation(.bouncy, value: viewModel.selectedTab)
                            
                            TabView (selection: $viewModel.selectedTab) {
                                PollMadeByMeList(
                                    pollMadeByMeList: (viewModel.createdByMePollList.isEmpty && !viewModel.createdByMePollIsEnd) ? PollItem.tempDataList() : viewModel.createdByMePollList,
                                    requestAddPoll: $viewModel.createdByMePollRequestAdd,
                                    isEnd: $viewModel.createdByMePollIsEnd
                                )
                                .tag(MyPollSelectedTab.createdByMe)
                                .background(GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: MadeByMeTabHeightPreferenceKey.self, value: proxy.size.height) // 크기 추적
                                })
                                .onAppear {
                                    Task {
                                        await viewModel.getPollsCreatedByMe()
                                    }
                                }
                                .onChange(of: viewModel.createdByMePollRequestAdd) { _, newValue in
                                    if newValue {
                                        Task {
                                            await viewModel.fetchPollsCreatedByMe()
                                        }
                                    }
                                }
                                
                                
                                PollFavoriteByMeList(
                                    pollFavoriteByMeList: (viewModel.favoriteByMePollList.isEmpty && !viewModel.favoriteByMePollIsEnd) ? PollItem.tempDataList() : viewModel.favoriteByMePollList,
                                    favoritePolls: authManager.favoritePolls,
                                    requestAddPoll: $viewModel.favoriteByMePollRequestAdd,
                                    isEnd: $viewModel.favoriteByMePollIsEnd,
                                    createFavorite: { pollHashId in
                                        Task {
                                            await viewModel.createFavorite(pollHashId: pollHashId)
                                        }
                                    }, deleteFavorite: { pollHashId in
                                        Task {
                                            await viewModel.deleteFavorite(pollHashId: pollHashId)
                                        }
                                    }
                                )
                                .tag(MyPollSelectedTab.faovirteByMe)
                                .background(GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: FavoriteByMeTabHeightPreferenceKey.self, value: proxy.size.height) // 크기 추적
                                })
                                .onAppear {
                                    Task {
                                        await viewModel.getPollsFavoriteByMe()
                                    }
                                }
                                .onChange(of: viewModel.favoriteByMePollRequestAdd) { _, newValue in
                                    if newValue {
                                        Task {
                                            await viewModel.fetchPollsFavoriteByMe()
                                        }
                                    }
                                }
                                
                                PollParticipatedList(
                                    pollParticipatedList: (viewModel.participatedPollList.isEmpty && !viewModel.participatedPollIsEnd) ? PollItem.tempDataList() : viewModel.participatedPollList,
                                    requestAddPoll: $viewModel.participatedPollRequestAdd,
                                    isEnd: $viewModel.participatedPollIsEnd
                                )
                                .tag(MyPollSelectedTab.participated)
                                .background(GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: ParticipatedTabHeightPreferenceKey.self, value: proxy.size.height)
                                })
                                .onAppear {
                                    Task {
                                        await viewModel.getPollsParticipated()
                                    }
                                }
                                .onChange(of: viewModel.participatedPollRequestAdd) { _, newValue in
                                    if newValue {
                                        Task {
                                            await viewModel.fetchPollsParticipated()
                                        }
                                    }
                                }
                                
                            }
                            .frame(height: viewModel.currentTabHeight) // 현재 선택된 탭의 높이만 사용
                            .onPreferenceChange(MadeByMeTabHeightPreferenceKey.self) { value in
                                if viewModel.madeByMeTabHeight != value {
                                    viewModel.madeByMeTabHeight = value
                                    viewModel.updateCurrentTabHeight()
                                }
                            }
                            .onPreferenceChange(FavoriteByMeTabHeightPreferenceKey.self) { value in
                                if viewModel.favoriteByMeTabHeight != value {
                                    viewModel.favoriteByMeTabHeight = value
                                    viewModel.updateCurrentTabHeight()
                                }
                            }
                            .onPreferenceChange(ParticipatedTabHeightPreferenceKey.self) { value in
                                if viewModel.participatedTabHeight != value {
                                    viewModel.participatedTabHeight = value
                                    viewModel.updateCurrentTabHeight()
                                }
                            }
                            .onChange(of: viewModel.selectedTab) {
                                viewModel.updateCurrentTabHeight()
                            }
                            
                            LogoutButton {
                                viewModel.isClickedLogoutButton = true
                            }
                        }
                        .ignoresSafeArea(.all)
                        .padding(.top)
                        .sheet(isPresented: $viewModel.isClickedProfileImage) {
                            ImageDetailView(imageUrl: authManager.userData?.profileImageUrl ?? "")
                        }
                        .onChange(of: scrollToTopTrigger) { _, newValue in
                            if newValue {
                                scrollToTopTrigger = false
                                withAnimation {
                                    parentScrollProxy.scrollTo("Top", anchor: .bottom)
                                }
                            }
                        }
                    }
                    //                .onAppear {
                    //                    
                    //                    Task {
                    //                        await viewModel.getPollsCreatedByMe()
                    //                        await viewModel.getPollsFavoriteByMe()
                    //                        await viewModel.getPollsParticipated()
                    //                    }
                    //                }
                    .refreshable(action: viewModel.loadPolls)
                    .dialog(
                        isPresented: $viewModel.isClickedLogoutButton,
                        title: "로그아웃",
                        content: Text("로그아웃 하시겠습니까?"),
                        primaryButtonText: "확인",
                        secondaryButtonText: "취소",
                        onPrimaryButton: {
                            Task {
                                await viewModel.logout()
                            }
                        }
                    )
                }
                
                
            } else {
                VStack (spacing: 20) {
                    Spacer()
                    
                    VStack {
                        Text("모든 기능을 이용하려면")
                        Text("로그인을 해주세요.")
                    }
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
        .onAppear {
            viewModel.setAuthManager(authManager)
            if authManager.isLoggedIn {
                Task {
                    await viewModel.getUser()
                    await viewModel.getFavoritePolls()
                    await viewModel.createAppNotification()
                }
            }
            
        }
        .onChange(of: authManager.isLoggedIn, { _, newValue in
            if !newValue {
                viewModel.showLogoutedDialog = true
                viewModel.resetPollsCreatedByMe()
                viewModel.resetPollsFavoriteByMe()
                viewModel.resetPollsParticipated()
                viewModel.selectedTab = .createdByMe
            }
        })
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "My투표 오류",
            content: Text("\(viewModel.errorMessage)")
        )
        .dialog(
            isPresented: $viewModel.showLogoutedDialog,
            title: "My투표",
            content: Text(authManager.justDeletedAccount ? "회원 탈퇴가 완료되었습니다." : authManager.sessionExpired ? "세션이 만료되었습니다." : "로그아웃 되었습니다."),
            onPrimaryButton: {
                authManager.justDeletedAccount = false
                authManager.sessionExpired = false
            }
        )
    }
}

#Preview {
    MyPollView(scrollToTopTrigger: .constant(false), isHideTabBar: .constant(false))
}
