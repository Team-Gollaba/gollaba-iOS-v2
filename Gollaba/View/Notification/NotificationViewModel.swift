//
//  NotificationViewModel.swift
//  Gollaba
//
//  Created by 김견 on 1/28/25.
//

import SwiftUI

@Observable
class NotificationViewModel {
    //MARK: - Properties
    
    //MARK: - Flag
    var showErrorDialog: Bool = false
    
    //MARK: - Data
    var pushNotificationData: PushNotificationDatas?
    var pushNotificationListRequestAdd: Bool = false
    var pushNotificationListIsEnd: Bool = false
    var pushNotificationListPage: Int = 0
    let pushNotificationListSize: Int = 10
    
    private(set) var errorMessage: String = ""
    
    //MARK: - API
    func getPushNotificationList() async {
        guard self.pushNotificationData?.items.isEmpty ?? true else { return }
        
        do {
            self.pushNotificationData = try await ApiManager.shared.getPushNotificationHistory(page: self.pushNotificationListPage, size: self.pushNotificationListSize)
            self.pushNotificationListPage += 1
            self.pushNotificationListIsEnd = self.pushNotificationData?.items.count == self.pushNotificationData?.totalCount
        } catch {
            handleError(error: error)
        }
    }
    
    func fetchPushNotificationList() async {
        if self.pushNotificationListIsEnd { return }
        
        do {
            let newNotiData = try await ApiManager.shared.getPushNotificationHistory(page: self.pushNotificationListPage, size: self.pushNotificationListSize)
            self.pushNotificationListPage += 1
            self.pushNotificationData?.items.append(contentsOf: newNotiData.items)
            self.pushNotificationListRequestAdd = false
            print("newNotiData.totalCount: \(newNotiData.totalCount), self.pushNotificationData?.items.count: \(self.pushNotificationData?.items.count ?? 0)")
            self.pushNotificationListIsEnd = newNotiData.totalCount == self.pushNotificationData?.items.count
        } catch {
            handleError(error: error)
        }
    }
    
    //MARK: - ETC
    func resetPage() {
        self.pushNotificationListPage = 0
        self.pushNotificationListIsEnd = false
        self.pushNotificationData = nil
    }
    
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        
        if let apiError = error as? ApiError {
            switch apiError {
            case .serverError(_, let message):
                self.errorMessage = message
            default:
                break
            }
        }
        self.showErrorDialog = true
    }
}
