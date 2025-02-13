//
//  DeepLinkManager.swift
//  Gollaba
//
//  Created by 김견 on 2/13/25.
//

import SwiftUI

@Observable
class DeepLinkManager {
    
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        if components.host == "notification",
           let pollHashId = components.queryItems?.first(where: { $0.name == "pollHashId"} )?.value {
            DispatchQueue.main.async {
                MainViewModel.shared.pollHashId = pollHashId
            }
        }
    }
}
