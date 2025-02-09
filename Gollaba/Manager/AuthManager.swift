//
//  AuthManager.swift
//  Gollaba
//
//  Created by 김견 on 12/24/24.
//

import SwiftUI
import Alamofire

@Observable
class AuthManager {
    var isLoggedIn: Bool {
        get {
            jwtToken != nil
        }
    }
    var jwtToken: String?
    var providerType: ProviderType = .none
    var favoritePolls: [String] = []
    
    var userData: UserData?
    
    var profileImageUrl: URL? {
        get {
            switch providerType {
            case .kakao:
                return kakaoAuthManager.profileImageUrl
                
            default:
                return nil
            }
        }
    }
    
    let kakaoAuthManager: KakaoAuthManager = KakaoAuthManager()
    
    func kakaoLogin() async throws {
        do {
            try await kakaoAuthManager.handleKakaoLogin()
            providerType = .kakao
        } catch {
            throw error
        }
    }
    
    func kakaoLogout() async throws {
        if await kakaoAuthManager.kakaoLogout() {
            resetAuth()
        } else {
            throw KakaoLogoutError.invalidResponse
        }
    }
    
    func resetAuth() {
        self.jwtToken = nil
        self.providerType = .none
        self.favoritePolls.removeAll()
        self.userData = nil
    }
}
