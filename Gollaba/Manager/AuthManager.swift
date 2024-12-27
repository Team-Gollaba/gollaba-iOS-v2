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
            if let jwtToken {
                return true
            } else {
                return false
            }
        }
    }
    var jwtToken: String?
    
    var kakaoAuthManager: KakaoAuthManager = KakaoAuthManager()
}
