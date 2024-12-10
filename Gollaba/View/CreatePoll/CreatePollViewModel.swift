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
    var pollHashId: String = ""
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
    var selectedDate: Date = Date().addingTimeInterval(60 * 60)
    
    var creatorNameFocus: Bool = true
    var titleFocus: Bool = false
    
    var isPollItemFocused: Bool = false
    var isPollCreatorNameFocused: Bool = false
    var isPollTitleFocused: Bool = false
    
    var selectedItem: [PhotosPickerItem?] = Array(repeating: nil, count: 6)
    var postImage: [Image?] = Array(repeating: nil, count: 6)
    var uiImage: [UIImage?] = Array(repeating: nil, count: 6)
    
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    func convertImage(item: PhotosPickerItem?, index: Int) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.postImage[index] = imageSelection.image
        self.uiImage[index] = imageSelection.uiImage
    }
    
    func createPoll() async {
        
        do {
            var pollOptionForParameters: [PollOptionForParameter] = []
            for (index, item) in pollItemName.enumerated() {
                if item.isEmpty { continue }
                let pollOptionForParameter = PollOptionForParameter(description: item, image: uiImage[index] ?? nil)
                
                pollOptionForParameters.append(pollOptionForParameter)
            }
            
            self.pollHashId = try await ApiManager.shared.createPoll(
                title: titleText,
                creatorName: creatorNameText,
                responseType: responseType,
                pollType: pollType,
                endAt: selectedDate,
                items: pollOptionForParameters
            )
            
            self.creatorNameText = ""
            self.titleText = ""
            self.postImage = Array(repeating: nil, count: 6)
            self.pollItemName = [
                "", "", "",
            ]
            self.anonymousOption = .first
            self.countingOption = .first
            self.selectedDate = Date().addingTimeInterval(60 * 60)
            self.alertMessage = "투표가 생성되었습니다."
            self.showAlert = true
        } catch {
            
        }
    }
    
    func isValidForCreatePoll() -> Bool {
        if creatorNameText.isEmpty {
            self.alertMessage = "투표 작성자 이름을 입력해주세요."
            self.showAlert = true
            return false
        }
        
        if titleText.isEmpty {
            self.alertMessage = "투표 제목을 입력해주세요."
            self.showAlert = true
            return false
        }
        
        if pollItemName.dropLast().contains("") {
            self.alertMessage = "투표 항목을 모두 입력해주세요."
            self.showAlert = true
            return false
        }
        
        let currentDate = Date()
        let thirtyMinutesLater = currentDate.addingTimeInterval(30 * 60)
        if selectedDate < thirtyMinutesLater {
            self.alertMessage = "투표 시작 날짜는 30분 이후로 설정해주세요."
            self.showAlert = true
            return false
        }
        return true
    }
}
