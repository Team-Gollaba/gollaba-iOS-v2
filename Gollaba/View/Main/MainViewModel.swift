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
    
    func handleUniversalLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        let pathComponents = components.path.split(separator: "/")
        
        if pathComponents.count >= 3, pathComponents[0] == "voting", pathComponents[1] == "pollHashId" {
            let pollHashId = String(pathComponents[2])
            pollHashIdFromURL = pollHashId
            print("🔗 pollHashIdFromURL: \(pollHashIdFromURL ?? "")")
            goToDetailView = true
        }
    }
}
