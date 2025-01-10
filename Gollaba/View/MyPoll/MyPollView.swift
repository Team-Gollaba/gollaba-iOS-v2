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
    @State var titleText: String = ""
    @State var contentText: String = ""
    
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
                ScrollView {
                    VStack (spacing: 0) {
                        ProfileImageView(
                            imageUrl: viewModel.userData?.profileImageUrl
                        ) {
                            viewModel.isClickedProfileImage = true
                        }
                        .frame(width: 100, height: 100)
                        
                        
                        ProfileNameView(name: $viewModel.userName, email: viewModel.userData?.email ?? "")
                            .padding(.top, 12)
                            .padding(.bottom, 24)
                            .onChange(of: viewModel.userName) { oldValue, newValue in
                                if oldValue != "" {
                                    Task {
                                        await viewModel.updateUserName()
                                    }
                                }
                            }
                        
//                            TextField("제목", text: $titleText)
//                        TextField("내용", text: $contentText)
//                        
//                        Button {
//                            Task {
//                                await viewModel.sendToServerMessage(title: titleText, content: contentText)
//                                titleText = ""
//                                contentText = ""
//                            }
//                        } label: {
//                            Text("전송")
//                        }
//                        
                        
                        HStack {
                            Button {
                                viewModel.selectedTab = .madeByMe
                            } label: {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(viewModel.selectedTab == .madeByMe ? .enrollButton : .gray)
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
                                pollMadeByMeList: viewModel.madeByMePollList.isEmpty ? viewModel.tempPolls : viewModel.madeByMePollList,
                                requestAddPoll: $viewModel.madeByMePollRequestAdd,
                                isEnd: $viewModel.madeByMePollIsEnd,
                                activateAnimation: $viewModel.activateAnimation
                            )
                            .tag(MyPollSelectedTab.madeByMe)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .preference(key: MadeByMeTabHeightPreferenceKey.self, value: proxy.size.height) // 크기 추적
                            })
                            
                            
                            PollFavoriteByMeList(
                                pollFavoriteByMeList: viewModel.favoriteByMePollList.isEmpty ? viewModel.tempPolls : viewModel.favoriteByMePollList,
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
                            
                            PollParticipatedList(
                                pollParticipatedList: viewModel.participatedPollList.isEmpty ? viewModel.tempPolls : viewModel.participatedPollList,
                                requestAddPoll: $viewModel.participatedPollRequestAdd,
                                isEnd: $viewModel.participatedPollIsEnd
                            )
                            .tag(MyPollSelectedTab.participated)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ParticipatedTabHeightPreferenceKey.self, value: proxy.size.height)
                            })
                            
                        }
                        .frame(height: viewModel.currentTabHeight) // 현재 선택된 탭의 높이만 사용
                        .onPreferenceChange(MadeByMeTabHeightPreferenceKey.self) { value in
                            viewModel.madeByMeTabHeight = value // 각 탭의 높이를 저장
                            viewModel.updateCurrentTabHeight() // 현재 탭 높이 업데이트
                        }
                        .onPreferenceChange(FavoriteByMeTabHeightPreferenceKey.self) { value in
                            viewModel.favoriteByMeTabHeight = value // 각 탭의 높이를 저장
                            viewModel.updateCurrentTabHeight() // 현재 탭 높이 업데이트
                        }
                        .onPreferenceChange(ParticipatedTabHeightPreferenceKey.self) { value in
                            viewModel.participatedTabHeight = value
                            viewModel.updateCurrentTabHeight()
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
                    }
                    .ignoresSafeArea(.all)
                    .padding(.top)
                    .sheet(isPresented: $viewModel.isClickedProfileImage) {
                        ProfileImageDetailView(image: KFImage(URL(string: viewModel.userData?.profileImageUrl ?? "")))
                    }
                    .onAppear {
                        Task {
                            await viewModel.getPollsCreatedByMe()
                            await viewModel.getPollsFavoriteByMe()
                            await viewModel.getPollsParticipated()
                        }
                    }
                    .onDisappear {
                        viewModel.resetPollsCreatedByMe()
                        viewModel.resetPollsFavoriteByMe()
                    }
                }
                .refreshable(action: viewModel.loadPolls)
                .dialog(
                    isPresented: $viewModel.isClickedLogoutButton,
                    title: "로그아웃",
                    content: Text("로그아웃 하시겠습니까?"),
                    primaryButtonText: "확인",
                    secondaryButtonText: "취소",
                    onPrimaryButton: {
                        Task {
                            await viewModel.kakaoLogout()
                            viewModel.resetPollsCreatedByMe()
                            viewModel.resetPollsFavoriteByMe()
                        }
                    }
                )
                
                
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
        .onAppear {
            viewModel.authManager = authManager
            if authManager.isLoggedIn {
                Task {
                    await viewModel.getUser()
                    await viewModel.getFavoritePolls()
                    await viewModel.createAppNotification()
                }
            }
        }
    }
}

#Preview {
    MyPollView(isHideTabBar: .constant(false))
}
