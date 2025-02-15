//
//  KakaoAuthManager.swift
//  Gollaba
//
//  Created by 김견 on 11/24/24.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

enum KakaoLoginError: Error {
    case invalidResponse
    case invalidAccessToken
}

enum KakaoLogoutError: Error {
    case invalidResponse
}

@Observable
class KakaoAuthManager {
    var isLoggedIn: Bool = false
    var userName: String = "유저"
    var userMail: String = ""
    var profileImageUrl: URL?
    var accessToken: String?
    
    @MainActor
    func handleKakaoLogin() async throws {
        
        // 카카오톡 실행 가능 여부 확인 - 설치 되어있을 경우
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 앱을 통해 로그인
            isLoggedIn = await handleLoginWithKakaoTalkApp()
        } else { // 설치 안 되어있을 때
            // 카카오 웹뷰를 통해 로그인
            isLoggedIn = await handleLoginWithKakaoAccount()
        }
        
        if !isLoggedIn {
            throw KakaoLoginError.invalidResponse
        }
    }
    
    @MainActor
    func kakaoLogout() async -> Bool {
        print("kakaoLogout")
        if await handleKakaoLogout() {
            isLoggedIn = false
            userName = "유저"
            userMail = ""
            profileImageUrl = nil
            
            return true
        } else {
            return false
        }
        
    }
    
    @MainActor
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error {
                    Logger.shared.log(String(describing: self), #function, "Failed to login with KakaoTalk with error: \(error)", .error)
                    continuation.resume(returning: false)
                } else {
                    UserApi.shared.me {(me, error) in
                        if let error {
                            Logger.shared.log(String(describing: self), #function, "Failed to get user information with error: \(error)", .error)
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
    
    @MainActor
    func handleLoginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error {
                    Logger.shared.log(String(describing: self), #function, "Failed to login with KakaoAccount with error: \(error)", .error)
                    continuation.resume(returning: false)
                } else {
                    UserApi.shared.me {(me, error) in
                        if let error {
                            Logger.shared.log(String(describing: self), #function, "Failed to get user information with error: \(error)", .error)
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
    
    
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            print("handleKakaoLogout(")
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
