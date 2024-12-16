//
//  KakaoAuthManager.swift
//  Gollaba
//
//  Created by 김견 on 11/24/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

@Observable
class KakaoAuthManager {
    var isLoggedIn: Bool = false
    var userName: String = "유저"
    var userMail: String = ""
    var profileImageUrl: URL?
    var accessToken: String?
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
                userName = "유저"
                userMail = ""
                profileImageUrl = nil
            }
        }
    }
    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    UserApi.shared.me {(me, error) in
                        if let error {
                            print(error)
                        }
                        
                        guard let name = me?.kakaoAccount?.profile?.nickname else {
                            return
                        }
                        
                        guard let mail = me?.kakaoAccount?.email else {
                            return
                        }
                        
                        guard let profileUrl = me?.kakaoAccount?.profile?.profileImageUrl else {
                            return
                        }
                        print("kakao user: \(name), \(mail), \(profileUrl)")
                        self.userName = name
                        self.userMail = mail
                        self.profileImageUrl = profileUrl
                    }
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    self.accessToken = oauthToken?.accessToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func handleLoginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func handleKakaoLogin() async {
        
        // 카카오톡 실행 가능 여부 확인 - 설치 되어있을 경우
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 앱을 통해 로그인
            isLoggedIn = await handleLoginWithKakaoTalkApp()
        } else { // 설치 안 되어있을 때
            // 카카오 웹뷰를 통해 로그인
            isLoggedIn = await handleLoginWithKakaoAccount()
        }
        
    }
    
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
}
