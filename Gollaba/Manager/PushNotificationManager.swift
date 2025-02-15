//
//  DeepLinkManager.swift
//  Gollaba
//
//  Created by 김견 on 2/13/25.
//

import SwiftUI

@Observable
class PushNotificationManager {
    var pushData: [AnyHashable: Any]? = nil
    var receivedPollHashId: String? = nil
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePushNotification(_:)),
            name: .pushNotificationReceived,
            object: nil
        )
    }
    
    @objc private func handlePushNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            DispatchQueue.main.async {
                self.pushData = userInfo
                Logger.shared.log(String(describing: self), #function, "Push Data: \(String(describing: self.pushData))")
                
                if let deepLink = userInfo["deepLink"] as? String {
                    if let urlComponents = URLComponents(string: deepLink),
                       let queryItems = urlComponents.queryItems {
                        if let pollHashId = queryItems.first(where: { $0.name == "pollHashId" })?.value {
                            self.receivedPollHashId = pollHashId
                        }
                    }
                }
            }
        }
    }
}
