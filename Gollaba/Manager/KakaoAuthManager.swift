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
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    func handleLoginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    // 성공 시 동작 구현
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func handleKakaoLogin() {
        Task {
            // 카카오톡 실행 가능 여부 확인 - 설치 되어있을 경우
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
            } else { // 설치 안 되어있을 때
                // 카카오 웹뷰를 통해 로그인
                isLoggedIn = await handleLoginWithKakaoAccount()
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
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
