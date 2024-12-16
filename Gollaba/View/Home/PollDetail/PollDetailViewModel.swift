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
    
    var inputNameText: String = ""
    var inputNameFocused: Bool = false
    
    var showAlreadyVotedAlert: Bool = false
    
    var inValidVoteAlert: Bool = false
    var inValidVoteAlertContent: String = ""
    
    var isValidDatePoll: Bool {
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
    func getPoll() async {
        
        do {
            self.poll = try await ApiManager.shared.getPoll(pollHashId: self.id)
            
            if let poll {
                selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
                pollButtonState = isValidDatePoll ? .normal : .ended
                
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
            }
        } catch {
            
        }
        
    }
    
    func readPoll() async {
        
        do {
            try await ApiManager.shared.readPoll(pollHashId: self.id)
            
        } catch {
            
        }
        
    }
    
    func votingCheck() async {
        
        do {
            if let poll {
                isVoted = try await ApiManager.shared.votingCheck(pollHashId: poll.id)
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
            }
        } catch {
            
        }
        
    }
    
    @Sendable func loadPoll() async {
        do {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await getPoll()
            await votingCheck()
        } catch {
            
        }
    }
    
    func voting() async {
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
            
            do {
                try await ApiManager.shared.voting(pollHashId: self.id, pollItemIds: pollItemIds, voterName: poll.pollType == PollType.named.rawValue ? voterName : nil)
                
                self.isVoted = true
            } catch {
                if let votingError = error as? VotingError, votingError == VotingError.alreadyVoted {
                    self.showAlreadyVotedAlert = true
                }
            }
            
        } else {
            
        }
    }
    
    func isCompletedVoting() -> Bool {
        if isVoted {
            self.showAlreadyVotedAlert = true
            return false
        }
        
        if let poll {
            if poll.pollType == PollType.named.rawValue && inputNameText.isEmpty {
                self.inValidVoteAlertContent = "닉네임을 입력해주세요."
                self.inValidVoteAlert = true
                
                return false
            } else if poll.responseType == ResponseType.single.rawValue && selectedSinglePoll == nil {
                self.inValidVoteAlertContent = "투표를 선택해주세요."
                self.inValidVoteAlert = true
                
                return false
            } else if poll.responseType == ResponseType.multiple.rawValue && selectedMultiplePoll.isEmpty {
                self.inValidVoteAlertContent = "투표를 선택해주세요. (최소 1개)"
                self.inValidVoteAlert = true
                
                return false
            } else {
                return true
            }
        } else {
            self.inValidVoteAlertContent = "데이터 오류입니다."
            self.inValidVoteAlert = true
            
            return false
        }
    }
}
