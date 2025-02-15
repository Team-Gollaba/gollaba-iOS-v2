//
//  ContentView.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
        MainView()
            .onAppear {
                if let accessToken = AppStorageManager.shared.accessToken {
                    authManager.jwtToken = accessToken
                }
                
                authManager.providerType = AppStorageManager.shared.providerType
            }
    }
}

#Preview {
    ContentView()
}
