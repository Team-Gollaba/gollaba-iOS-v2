//
//  CreatePollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

@Observable
class CreatePollViewModel {
    //MARK: - Properties
    private let pollsUseCase: PollsUseCaseProtocol
    
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
    var showPHPicker: [Bool] = Array(repeating: false, count: 6)
    var postImage: [Image?] = Array(repeating: nil, count: 6)
    var uiImage: [UIImage?] = Array(repeating: nil, count: 6)
    
    //MARK: - Dialog Message
    private(set) var completedMessage: String = ""
    private(set) var errorMessage: String = ""
    
    //MARK: - Initialize
    init(pollsUseCase: PollsUseCaseProtocol) {
        self.pollsUseCase = pollsUseCase
    }
    
    //MARK: - Image
    func updatePostImage(index: Int, image: UIImage?) {
        self.uiImage[index] = image
        if let image {
            self.postImage[index] = Image(uiImage: image)
        } else {
            self.postImage[index] = nil
        }
    }

    //MARK: - API
    func createPoll() async {
        self.isLoading = true
        
        var pollOptionForParameters: [PollOptionForParameter] = []
        for (index, item) in self.pollItemName.enumerated() {
            if item.isEmpty { continue }
            let pollOptionForParameter = PollOptionForParameter(description: item, image: self.uiImage[index] ?? nil)
            
            pollOptionForParameters.append(pollOptionForParameter)
        }
        
        let result = await pollsUseCase.createPoll(
            title: self.titleText,
            creatorName: self.creatorNameText,
            responseType: self.responseType,
            pollType: self.pollType,
            endAt: removeSecond(self.selectedDate),
            items: pollOptionForParameters
        )
        
        switch result {
        case .success(let pollHashId):
            self.pollHashId = pollHashId
            contentReset()
            self.goToPollDetail = true
        case .failure(let error):
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
        
        self.showPHPicker = Array(repeating: false, count: 6)
        self.postImage = Array(repeating: nil, count: 6)
        self.uiImage = Array(repeating: nil, count: 6)
    }
    
    func removeSecond(_ date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.second = 0
        return Calendar.current.date(from: components) ?? date
    }
    
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
