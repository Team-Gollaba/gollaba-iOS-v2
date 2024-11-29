//
//  PollDetailViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import SwiftUI

@Observable
class PollDetailViewModel {
    var poll: PollItem
    var selectedSinglePoll: Int? = nil
    var selectedMultiplePoll: [Bool] = []
    var pollButtonState: PollButtonState = .normal

    var isValidPoll: Bool {
        get {
            getState(poll.endAt)
        }
    }
    
    init(poll: PollItem) {
        self.poll = poll
        selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
        pollButtonState = isValidPoll ? .normal : .ended
    }
    
    func deleteOption() {
        selectedSinglePoll = nil
        selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
    }
    
    private func setDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    private func getState(_ dateString: String) -> Bool {
        let date = setDate(dateString)
        return date > Date()
    }
    
    //MARK: - API
    func readPoll() {
        Task {
            do {
                try await ApiManager.shared.readPoll(poll.id)
            } catch {
                
            }
        }
    }
}
