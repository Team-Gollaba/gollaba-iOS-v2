//
//  ImageManager.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI
import PhotosUI

struct ImageSelection {
    let image: Image
    let uiImage: UIImage
}

class ImageManager {
    
    static func convertImage(item: PhotosPickerItem?) async -> ImageSelection? {
        guard let item = item else { return nil }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        let image = Image(uiImage: uiImage)
        let imageSelection = ImageSelection(image: image, uiImage: uiImage)
        return imageSelection
    }
    
//    static func uploadImage(uiImage: UIImage, path: ImagePath) async -> String? {
//        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return nil }
//        let fileName = UUID().uuidString
//        print("fileName: ", fileName)
//        var imagePath: String = ""
//        
//        switch path {
//        case .post:
//            imagePath = "images"
//        case .profile:
//            imagePath = "profiles"
//        }
//        
//        let reference = Storage.storage().reference(withPath: "/\(imagePath)/\(fileName)")
//        do {
//            let metadData = try await reference.putDataAsync(imageData)
//            print("metaData: ", metadData)
//            let url = try await reference.downloadURL()
//            return url.absoluteString
//        } catch {
//            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
//            return nil
//        }
//    }
}
