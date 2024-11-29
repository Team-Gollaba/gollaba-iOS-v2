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
    
    init(poll: PollItem) {
        self.poll = poll
        selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
    }
    
    func deleteOption() {
        selectedSinglePoll = nil
        selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
    }
}
