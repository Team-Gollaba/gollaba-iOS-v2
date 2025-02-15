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
    
    private(set) var isCompletedCreatePoll: Bool = false
    var goToPollDetail: Bool = false
    
    var showQuestionBeforeCreatePollDialog: Bool = false
    var showErrorDialog: Bool = false
    
    var isLoading: Bool = false
    
    //MARK: - Data
    private(set) var pollHashId: String = ""
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
    private(set) var completedMessage: String = ""
    private(set) var errorMessage: String = ""
    
    //MARK: - Image
    func convertImage(item: PhotosPickerItem?, index: Int) async {
        guard let imageSelection = await ImageManager.convertImage(item: item) else { return }
        self.postImage[index] = imageSelection.image
        self.uiImage[index] = imageSelection.uiImage
    }
    
    //MARK: - API
    func createPoll() async {
        self.isLoading = true
        
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
                endAt: removeSecond(self.selectedDate),
                items: pollOptionForParameters
            )
            
            contentReset()
            self.goToPollDetail = true
        } catch {
            handleError(error: error)
        }
        
        self.isLoading = false
    }
    
    //MARK: - Check Valid
    func isValidForCreatePoll() -> Bool {
        let currentDate = Date()
        let thirtyMinutesLater = currentDate.addingTimeInterval(30 * 60)
        
        return !creatorNameText.isEmpty && !titleText.isEmpty && !pollItemName.dropLast().contains("") && !(selectedDate < thirtyMinutesLater)
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
    
    func removeSecond(_ date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.second = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        
        if let apiError = error as? ApiError {
            switch apiError {
            case .serverError(let message):
                self.errorMessage = message
            default:
                break
            }
        }
        self.showErrorDialog = true
    }
}
