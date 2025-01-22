//
//  SettingViewModel.swift
//  Gollaba
//
//  Created by 김견 on 1/22/25.
//

import SwiftUI
import PhotosUI

@Observable
class SettingViewModel {
    //MARK: - Properties
    
    //MARK: - Flag
    var showErrorDialog: Bool = false
    var showSetProfileImageDialog: Bool = false

    //MARK: - AppStorageData
    var isNotificationOn: Bool = AppStorageManager.shared.isNotificationEnabled
    var appStorageManager: AppStorageManager = AppStorageManager.shared
    
    //MARK: - Data
    var selectedItem: PhotosPickerItem?
    var postImage: Image?
    var uiImage: UIImage?
    private(set) var errorMessage: String = ""
    
    //MARK: - API
    func updateNotification() async {
        do {
            try await ApiManager.shared.updateAppPushNotification(
                agentId: self.appStorageManager.agentId ?? "",
                allowsNotification: self.isNotificationOn
            )
            self.appStorageManager.isNotificationEnabled = self.isNotificationOn
        } catch {
            handleError(error: error)
        }
    }
    
    func uploadImage() async -> String {
        do {
            if let uiImage = uiImage {
                let url = try await ApiManager.shared.uploadImage(images: [uiImage])
                return url.first ?? ""
            }
        } catch {
            handleError(error: error)
        }
        return ""
    }
    
    //MARK: - Image
    func convertImage(item: PhotosPickerItem?) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.postImage = imageSelection.image
        self.uiImage = imageSelection.uiImage
    }
    
    //MARK: - ETC
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
