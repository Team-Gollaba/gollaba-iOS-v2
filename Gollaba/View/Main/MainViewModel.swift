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
    var goToDetailView: Bool = false
    var pollHashIdFromURL: String? = nil
    var authManager: AuthManager?
    static let shared = MainViewModel()
    
    func getUserMe() async {
        do {
            let userData = try await ApiManager.shared.getUserMe()
            authManager?.userData = userData
        } catch {
            
        }
    }
    
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = url.host else { return }
        
        if host == "voting", let pollHashId = components.queryItems?.first(where: { $0.name == "pollHashId" })?.value {
            pollHashIdFromURL = pollHashId
            print("pollHashIdFromURL: \(pollHashIdFromURL ?? "")")
            goToDetailView = true
        }
    }
}
