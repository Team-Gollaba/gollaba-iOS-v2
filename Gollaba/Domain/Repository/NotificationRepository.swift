//
//  NotificationRepository.swift
//  Gollaba
//

import Foundation

protocol NotificationRepository {
    func fetchHistory(page: Int, size: Int) async throws -> PushNotificationDatas
    func register(agentId: String, allowsNotification: Bool) async throws
    func update(agentId: String, allowsNotification: Bool) async throws
}
