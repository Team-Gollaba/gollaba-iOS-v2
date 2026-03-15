//
//  NotificationRepository.swift
//  Gollaba
//

import Foundation

protocol NotificationRepositoryProtocol {
    func fetchHistory(page: Int, size: Int) async throws -> PushNotificationDatas
    func register(agentId: String, allowsNotification: Bool) async throws
    func update(agentId: String, allowsNotification: Bool) async throws
}

class NotificationRepositoryImpl: NotificationRepositoryProtocol {
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
