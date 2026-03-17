@testable import Gollaba
import Foundation

final class MockPushNotificationUseCase: PushNotificationUseCaseProtocol {
    var getPushNotificationHistoryResult: Result<PushNotificationDatas, NetworkError> = .success(.empty)
    var createAppPushNotificationResult: Result<Void, NetworkError> = .success(())
    var updateAppPushNotificationResult: Result<Void, NetworkError> = .success(())

    var getPushNotificationHistoryCallCount = 0

    func getPushNotificationHistory(page: Int, size: Int) async -> Result<PushNotificationDatas, NetworkError> {
        getPushNotificationHistoryCallCount += 1
        return getPushNotificationHistoryResult
    }

    func createAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        return createAppPushNotificationResult
    }

    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        return updateAppPushNotificationResult
    }
}

// MARK: - PushNotificationDatas helper
extension PushNotificationDatas {
    static var empty: PushNotificationDatas {
        PushNotificationDatas(items: [], page: 0, size: 10, totalCount: 0, totalPage: 0, empty: true)
    }

    static func make(items: [PushNotificationData], totalCount: Int? = nil) -> PushNotificationDatas {
        PushNotificationDatas(items: items, page: 0, size: 10, totalCount: totalCount ?? items.count, totalPage: 1, empty: items.isEmpty)
    }
}

// MARK: - PushNotificationData helper
extension PushNotificationData {
    static func mock(id: Int = 1) -> PushNotificationData {
        PushNotificationData(notificationId: id, userId: 1, deepLink: nil, title: "알림 제목", content: "알림 내용")
    }
}
