//
//  DefaultNotificationRepository.swift
//  Gollaba
//

import Foundation

class DefaultNotificationRepository: NotificationRepository {
    private let apiManager: any ApiManagerProtocol

    init(apiManager: any ApiManagerProtocol = ApiManager.shared) {
        self.apiManager = apiManager
    }

    func fetchHistory(page: Int, size: Int) async throws -> PushNotificationDatas {
        return try await apiManager.getPushNotificationHistory(page: page, size: size).get()
    }

    func register(agentId: String, allowsNotification: Bool) async throws {
        try await apiManager.createAppPushNotification(agentId: agentId, allowsNotification: allowsNotification).get()
    }

    func update(agentId: String, allowsNotification: Bool) async throws {
        try await apiManager.updateAppPushNotification(agentId: agentId, allowsNotification: allowsNotification).get()
    }
}
