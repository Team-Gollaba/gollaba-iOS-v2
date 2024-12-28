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
    
    var kakaoAuthManager: KakaoAuthManager = KakaoAuthManager()
}
