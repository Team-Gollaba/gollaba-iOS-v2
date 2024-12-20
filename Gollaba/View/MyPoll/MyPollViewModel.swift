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
    
    var madeByMePollList: [PollItem] = []
    var madeByMePollRequestAdd: Bool = false
    var madeByMePollIsEnd: Bool = false
    
    init() {
        for i in 1...10 {
            madeByMePollList.append(PollItem(id: "\(i)", title: "title \(i)", creatorName: "creator \(i)", responseType: "response \(i)", pollType: "pollType \(i)", endAt: "2024.12.12", readCount: 1, totalVotingCount: 8, items: [
                PollOption(id: 1, description: "desc", imageUrl: nil, votingCount: 2),
                PollOption(id: 2, description: "desc", imageUrl: nil, votingCount: 6)
            ]))
        }
    }
}
