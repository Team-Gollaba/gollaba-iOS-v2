//
//  PushNotificationResponse.swift
//  Gollaba
//
//  Created by 김견 on 1/28/25.
//

import Foundation

struct PushNotificationResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
    let data: PushNotificationDatas
}

struct PushNotificationDatas: Codable {
    var items: [PushNotificationData]
    let page: Int
    let size: Int
    let totalCount: Int
    let totalPage: Int
    let empty: Bool
}
