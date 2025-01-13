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
    //MARK: - Properties
    
    //MARK: - Flag
    var isQuestionPresent: Bool = false
    
    var showDatePicker: Bool = false
    var showTimePicker: Bool = false
    
    var isCompletedCreatePoll: Bool = false
    var goToPollDetail: Bool = false
    
    var showInvalidDialog: Bool = false
    var showCompletedDialog: Bool = false
    var showErrorDialog: Bool = false
    
    //MARK: - Data
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
    
    var selectedDate: Date = Date().addingTimeInterval(60 * 60)
    
    //MARK: - Focus
    var creatorNameFocus: Bool = true
    var titleFocus: Bool = false
    var isPollItemFocused: Bool = false
    
    //MARK: - Photos
    var selectedItem: [PhotosPickerItem?] = Array(repeating: nil, count: 6)
    var postImage: [Image?] = Array(repeating: nil, count: 6)
    var uiImage: [UIImage?] = Array(repeating: nil, count: 6)
    
    //MARK: - Dialog Message
    var invalidMessage: String = ""
    var completedMessage: String = ""
    var errorMessage: String = ""
    
    //MARK: - Image
    func convertImage(item: PhotosPickerItem?, index: Int) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.postImage[index] = imageSelection.image
        self.uiImage[index] = imageSelection.uiImage
    }
    
    //MARK: - API
    func createPoll() async {
        
        do {
            var pollOptionForParameters: [PollOptionForParameter] = []
            for (index, item) in self.pollItemName.enumerated() {
                if item.isEmpty { continue }
                let pollOptionForParameter = PollOptionForParameter(description: item, image: self.uiImage[index] ?? nil)
                
                pollOptionForParameters.append(pollOptionForParameter)
            }
            
            self.pollHashId = try await ApiManager.shared.createPoll(
                title: self.titleText,
                creatorName: self.creatorNameText,
                responseType: self.responseType,
                pollType: self.pollType,
                endAt: self.selectedDate,
                items: pollOptionForParameters
            )
            
            contentReset()
            self.completedMessage = "투표가 생성되었습니다."
            self.isCompletedCreatePoll = true
            self.showCompletedDialog = true
        } catch {
            handleError(error: error)
        }
    }
    
    //MARK: - Check Valid
    func isValidForCreatePoll() -> Bool {
        if creatorNameText.isEmpty {
            self.invalidMessage = "투표 작성자 이름을 입력해주세요."
            self.showInvalidDialog = true
            return false
        }
        
        if titleText.isEmpty {
            self.invalidMessage = "투표 제목을 입력해주세요."
            self.showInvalidDialog = true
            return false
        }
        
        if pollItemName.dropLast().contains("") {
            self.invalidMessage = "투표 항목을 모두 입력해주세요."
            self.showInvalidDialog = true
            return false
        }
        
        let currentDate = Date()
        let thirtyMinutesLater = currentDate.addingTimeInterval(30 * 60)
        if selectedDate < thirtyMinutesLater {
            self.invalidMessage = "투표 시작 날짜는 30분 이후로 설정해주세요."
            self.showInvalidDialog = true
            return false
        }
        return true
    }
    
    //MARK: - ETC
    func contentReset() {
        self.creatorNameText = ""
        self.titleText = ""
        self.postImage = Array(repeating: nil, count: 6)
        self.pollItemName = [
            "", "", "",
        ]
        self.anonymousOption = .first
        self.countingOption = .first
        self.selectedDate = Date().addingTimeInterval(60 * 60)
    }
    
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
