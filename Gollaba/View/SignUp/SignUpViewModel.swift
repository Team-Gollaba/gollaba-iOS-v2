//
//  SignUpViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/3/24.
//

import SwiftUI
import PhotosUI

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var nickName: String = ""
    
    @Published var emailFocused: Bool = false
    @Published var nickNameFocused: Bool = false
    
    @Published var selectedItem: PhotosPickerItem?
    @Published var image: Image?
    @Published var uiImage: UIImage?
    
    func convertImage(item: PhotosPickerItem?) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.image = imageSelection.image
        self.uiImage = imageSelection.uiImage
    }
}
