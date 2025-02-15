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
    let deepLink: String?
    let title: String
    let content: String
}

extension PushNotificationData {
    static func tempDataList() -> [PushNotificationData] {
        Array(
            repeating: PushNotificationData(
                notificationId: -1,
                userId: -1,
                deepLink: nil,
                title: "titletitletitletitle",
                content: "contentcontentcontent"
            ),
            count: 10
        )
    }
}
