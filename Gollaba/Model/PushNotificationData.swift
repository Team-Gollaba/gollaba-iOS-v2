//
//  PushNotificationData.swift
//  Gollaba
//
//  Created by 김견 on 1/28/25.
//

import Foundation

struct PushNotificationData: Codable {
    let notificationId: Int
    let userId: Int
    let agentId: String
    let eventId: Int?
    let deepLink: String?
    let title: String
    let content: String
}
