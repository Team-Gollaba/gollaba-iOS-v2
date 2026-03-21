//
//  DefaultNotificationRepository.swift
//  Gollaba
//

import Foundation

class DefaultNotificationRepository: NotificationRepository {
    func fetchHistory(page: Int, size: Int) async throws -> PushNotificationDatas {
        return try await ApiManager.shared.getPushNotificationHistory(page: page, size: size).get()
    }

    func register(agentId: String, allowsNotification: Bool) async throws {
        try await ApiManager.shared.createAppPushNotification(agentId: agentId, allowsNotification: allowsNotification).get()
    }

    func update(agentId: String, allowsNotification: Bool) async throws {
        try await ApiManager.shared.updateAppPushNotification(agentId: agentId, allowsNotification: allowsNotification).get()
    }
}
