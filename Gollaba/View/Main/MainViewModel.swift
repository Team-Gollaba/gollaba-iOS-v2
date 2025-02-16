//
//  MainViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

@Observable
class MainViewModel {
    var goToLogin = false
    var pollHashId: String?
    var authManager: AuthManager?
    static let shared = MainViewModel()
    
    func getUserMe() async {
        do {
            let userData = try await ApiManager.shared.getUserMe()
            authManager?.userData = userData
        } catch {
            
        }
    }
}
