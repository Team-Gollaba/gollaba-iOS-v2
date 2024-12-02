//
//  PollDetailViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import SwiftUI

@Observable
class PollDetailViewModel {
    var id: String
    var poll: PollItem?
    var selectedSinglePoll: Int? = nil
    var selectedMultiplePoll: [Bool] = []
    var pollButtonState: PollButtonState = .normal
    
    var isValidPoll: Bool {
        get {
            if let poll {
                getState(poll.endAt)
            } else {
                false
            }
        }
    }
    var isVoted: Bool = false
    
    init(id: String) {
        self.id = id
    }
    
    //    init(poll: PollItem) {
    //        self.poll = poll
    //        selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
    //        pollButtonState = isValidPoll ? .normal : .ended
    //    }
    
    func deleteOption() {
        selectedSinglePoll = nil
        
        if let poll {
            selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
        }
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
    func getPoll() {
        Task {
            do {
                poll = try await ApiManager.shared.getPoll(pollHashId: id)
                
                if let poll {
                    selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
                    pollButtonState = isValidPoll ? .normal : .ended
                    
                    readPoll()
                    votingCheck()
                }
            } catch {
                
            }
        }
    }
    
    func readPoll() {
        Task {
            do {
                if let poll {
                    try await ApiManager.shared.readPoll(pollHashId: poll.id)
                } else {
                    
                }
            } catch {
                
            }
        }
    }
    
    func votingCheck() {
        Task {
            do {
                if let poll {
                    isVoted = try await ApiManager.shared.votingCheck(pollHashId: poll.id)
                } else {
                    
                }
            } catch {
                
            }
        }
    }
    
    func voting() {
        var pollItemIds: [Int] = []
        let voterName = "temp voter"
    
        if let poll {
            if poll.responseType == ResponseType.single.rawValue, let selectedPollItemIndex = selectedSinglePoll {
                pollItemIds.append(poll.items[selectedPollItemIndex - 1].id)
            } else if poll.responseType == ResponseType.multiple.rawValue {
                for (index, selectedPollItemId) in selectedMultiplePoll.enumerated() {
                    if selectedPollItemId {
                        pollItemIds.append(poll.items[index].id)
                    }
                }
            }
            
            Task {
                do {
                    try await ApiManager.shared.voting(pollHashId: self.id, pollItemIds: pollItemIds, voterName: poll.pollType == PollType.named.rawValue ? voterName : nil)
                    
                } catch {
                    
                }
            }
        } else {
            
        }
    }
}
