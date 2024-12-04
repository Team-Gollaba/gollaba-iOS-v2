//
//  CreatePollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import PhotosUI

@Observable
class CreatePollViewModel {
    var titleText: String = ""
    var creatorNameText: String = ""
    var anonymousOption: Option = .first
    var countingOption: Option = .first
    
    var pollType: String {
        get {
            anonymousOption == .first ? "ANONYMOUS" : "NAMED"
        }
    }
    var responseType: String {
        get {
            countingOption == .first ? "SINGLE" : "MULTIPLE"
        }
    }
    
    var pollItemName: [String] = [
        "", "", "",
    ]
    var isQuestionPresent: Bool = false
    var showDatePicker: Bool = false
    var showTimePicker: Bool = false
    var selectedDate: Date = Date()
    
    var creatorNameFocus: Bool = true
    var titleFocus: Bool = false
    
    var isPollItemFocused: Bool = false
    var isPollCreatorNameFocused: Bool = false
    var isPollTitleFocused: Bool = false
    
    var selectedItem: [PhotosPickerItem?] = Array(repeating: nil, count: 6)
    var postImage: [Image?] = Array(repeating: nil, count: 6)
    var uiImage: [UIImage?] = Array(repeating: nil, count: 6)
    
    func convertImage(item: PhotosPickerItem?, index: Int) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.postImage[index] = imageSelection.image
        self.uiImage[index] = imageSelection.uiImage
    }
    
    func createPoll() {
        Task {
            do {
                var pollOptionForParameters: [PollOptionForParameter] = []
                for (index, item) in pollItemName.enumerated() {
                    if item.isEmpty { continue }
                    let pollOptionForParameter = PollOptionForParameter(description: item, image: uiImage[index] ?? nil)
                    
                    pollOptionForParameters.append(pollOptionForParameter)
                }
                
                try await ApiManager.shared.createPoll(
                    title: titleText,
                    creatorName: creatorNameText,
                    responseType: responseType,
                    pollType: pollType,
                    endAt: selectedDate,
                    items: pollOptionForParameters
                )
            }
        }
    }
}
