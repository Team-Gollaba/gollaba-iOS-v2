//
//  NotificationViewModel.swift
//  Gollaba
//
//  Created by 김견 on 1/28/25.
//

import SwiftUI

@MainActor
@Observable
class NotificationViewModel {
    //MARK: - Properties
    private let pushNotificationUseCase: PushNotificationUseCaseProtocol
    
    //MARK: - Flag
    var showErrorDialog: Bool = false
    
    //MARK: - Data
    var pushNotificationData: PushNotificationDatas?
    var pushNotificationListRequestAdd: Bool = false
    var pushNotificationListIsEnd: Bool = false
    var pushNotificationListPage: Int = 0
    let pushNotificationListSize: Int = 10
    
    private(set) var errorMessage: String = ""
    
    //MARK: - Initialize
    init(pushNotificationUseCase: PushNotificationUseCaseProtocol = PushNotificationUseCase()) {
        self.pushNotificationUseCase = pushNotificationUseCase
    }
    
    //MARK: - API
    
    func loadPushNotifications(isRefresh: Bool = false) async {
        if isRefresh {
            resetPage()
        } else if pushNotificationListIsEnd {
            return
        }
        
        let result = await pushNotificationUseCase.getPushNotificationHistory(page: pushNotificationListPage, size: pushNotificationListSize)
        
        switch result {
        case .success(let pushNotificationDatas):
            if isRefresh {
                pushNotificationData = pushNotificationDatas
            } else {
                pushNotificationData?.items.append(contentsOf: pushNotificationDatas.items)
            }
            pushNotificationListPage += 1
            pushNotificationListIsEnd = pushNotificationData?.items.count == pushNotificationDatas.totalCount
            
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    //MARK: - ETC
    func resetPage() {
        self.pushNotificationListPage = 0
        self.pushNotificationListIsEnd = false
        self.pushNotificationData = nil
    }
    
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
