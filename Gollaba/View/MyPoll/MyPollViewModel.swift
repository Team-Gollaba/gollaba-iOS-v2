//
//  MyPollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

enum MyPollSelectedTab: Int {
    case madeByMe = 0
    case like = 1
}

@Observable
class MyPollViewModel {
    var goToPollDetail: Bool = false
    var goToPollList: Bool = false
    var goToLogin: Bool = false
    var isClickedProfileImage: Bool = false
    var isClickedLogoutButton: Bool = false
    
    var pollListIcon: Image?
    var pollListTitle: String?
    
    var madeByMePollList: [PollItem] = []
    var madeByMePollRequestAdd: Bool = false
    var madeByMePollIsEnd: Bool = false
    
    var selectedTab: MyPollSelectedTab = .madeByMe
    var madeByMeTabHeight: CGFloat = 0
    var likeTabHeight: CGFloat = 0
    var currentTabHeight: CGFloat = 400
    
    var authManager: AuthManager?
    
    init() {
        for i in 1...10 {
            madeByMePollList.append(PollItem(id: "\(i)", title: "title \(i)", creatorName: "creator \(i)", creatorProfileUrl: "", responseType: "response \(i)", pollType: "pollType \(i)", endAt: "2024.12.12", readCount: 1, totalVotingCount: 8, items: [
                PollOption(id: 1, description: "desc", imageUrl: nil, votingCount: 2),
                PollOption(id: 2, description: "desc", imageUrl: nil, votingCount: 6)
            ]))
        }
    }
    
    func updateCurrentTabHeight() {
            switch selectedTab {
            case .madeByMe:
                currentTabHeight = madeByMeTabHeight
            case .like:
                currentTabHeight = likeTabHeight
            }
        }
    
    func kakaoLogout() async {
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is nil")
            return
        }
        
        do {
            try await authManager.kakaoLogout()
        } catch {
            
        }
    }
}
