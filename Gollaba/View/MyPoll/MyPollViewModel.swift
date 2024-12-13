//
//  MyPollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

@Observable
class MyPollViewModel {
    var goToPollDetail: Bool = false
    var goToPollList: Bool = false
    var isClickedProfileImage: Bool = false
    var isClickedLogoutButton: Bool = false
    
    var pollListIcon: Image?
    var pollListTitle: String?
    
    var madeByMePollList: [PollItem] = Array(repeating: PollItem(id: "1", title: "title", creatorName: "creator", responseType: "response", pollType: "pollType", endAt: "2024.12.12", readCount: 1, totalVotingCount: 10, items: [
        PollOption(id: 1, description: "desc", imageUrl: nil, votingCount: 1),
        PollOption(id: 2, description: "desc", imageUrl: nil, votingCount: 2)
    ]), count: 10)
    var madeByMePollRequestAdd: Bool = false
    var madeByMePollIsEnd: Bool = false
}
