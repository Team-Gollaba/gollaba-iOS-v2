//
//  PushNotificationUseCase.swift
//  Gollaba
//

import Foundation

protocol PushNotificationUseCaseProtocol {
    func getPushNotificationHistory(page: Int, size: Int) async -> Result<PushNotificationDatas, NetworkError>
    func createAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError>
    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError>
}

class PushNotificationUseCase: PushNotificationUseCaseProtocol {
    private let notificationRepository: NotificationRepositoryProtocol

    init(notificationRepository: NotificationRepositoryProtocol = NotificationRepositoryImpl()) {
        self.notificationRepository = notificationRepository
    }

    func getPushNotificationHistory(page: Int, size: Int) async -> Result<PushNotificationDatas, NetworkError> {
        do {
            let data = try await notificationRepository.fetchHistory(page: page, size: size)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func createAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        do {
            try await notificationRepository.register(agentId: agentId, allowsNotification: allowsNotification)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        do {
            try await notificationRepository.update(agentId: agentId, allowsNotification: allowsNotification)
            return .success(())
        } catch {
            return .failure(NetworkError.from(error))
        }
    }
}
