//
//  AppStorageManager.swift
//  Gollaba
//
//  Created by 김견 on 1/10/25.
//

import SwiftUI

class AppStorageManager {
    static let shared = AppStorageManager()
    
    @AppStorage("permissionForNotification") var permissionForNotification: Bool? // 앱 권한 (제일 바깥)
    @AppStorage("isNotificationEnabled") var isNotificationEnabled: Bool = true // 앱 내의 설정 화면에서 컨트롤
    @AppStorage("agentId") var agentId: String?
    @AppStorage("saveToNotificationServerSuccess") var saveToNotificationServerSuccess: Bool = false
}
