//
//  AuthManager.swift
//  Gollaba
//
//  Created by 김견 on 12/24/24.
//

import SwiftUI

@Observable
class AuthManager {
    var isLoggedIn: Bool {
        get {
            jwtToken != nil
        }
    }
    var jwtToken: String?
    
    let kakaoAuthManager: KakaoAuthManager = KakaoAuthManager()
    
    func kakaoLogin() async throws {
        do {
            try await kakaoAuthManager.handleKakaoLogin()
        } catch {
            throw error
        }
    }
    
    func kakaoLogout() async throws {
        if await kakaoAuthManager.kakaoLogout() {
            jwtToken = nil
        } else {
            throw KakaoLogoutError.invalidResponse
        }
    }
}
