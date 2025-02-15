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
    var justDeletedAccount: Bool = false
    var jwtToken: String? {
        didSet {
            AppStorageManager.shared.accessToken = jwtToken
        }
    }
    var providerType: ProviderType = .none {
        didSet {
            AppStorageManager.shared.providerType = providerType
        }
    }
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
        deleteRefreshToken()
        self.providerType = .none
        self.favoritePolls.removeAll()
        self.userData = nil
    }
    
    func deleteRefreshToken() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "refresh_token" {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
    }
    
    func logout() {
        switch self.providerType {
        case .kakao:
            Task {
                do {
                    try await kakaoLogout()
                } catch {
                    Logger.shared.log(String(describing: self), #function, "Failed to logout", .error)
                }
            }
        case .apple:
            self.resetAuth()
        default:
            break
        }
        
    }
}
