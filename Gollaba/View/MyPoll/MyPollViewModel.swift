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
    var goToLogin: Bool = false
    var isClickedProfileImage: Bool = false
    var isClickedLogoutButton: Bool = false
    
    var madeByMePollList: [PollItem] = []
    var madeByMePollRequestAdd: Bool = false
    var madeByMePollIsEnd: Bool = false
    var madeByMePollPage: Int = 0
    var madeByMePollSize: Int = 10
    
    var selectedTab: MyPollSelectedTab = .madeByMe
    var madeByMeTabHeight: CGFloat = 0
    var likeTabHeight: CGFloat = 0
    var currentTabHeight: CGFloat = 400
    
    var authManager: AuthManager?
    var userData: UserData?
    var userName: String = ""
    
//    init() {
//        for i in 1...10 {
//            madeByMePollList.append(PollItem(id: "\(i)", title: "title \(i)", creatorName: "creator \(i)", creatorProfileUrl: "", responseType: "response \(i)", pollType: "pollType \(i)", endAt: "2024.12.12", readCount: 1, totalVotingCount: 8, items: [
//                PollOption(id: 1, description: "desc", imageUrl: nil, votingCount: 2),
//                PollOption(id: 2, description: "desc", imageUrl: nil, votingCount: 6)
//            ]))
//        }
//    }
    
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
            Logger.shared.log(String(describing: self), #function, "authManager is nil", .error)
            return
        }
        
        do {
            try await authManager.kakaoLogout()
        } catch {
            
        }
    }
    
    func getUser() async {
        do {
            userData = try await ApiManager.shared.getUserMe()
            userName = userData?.name ?? ""
        } catch {
            
        }
    }
    
    func updateUserName() async {
        do {
            try await ApiManager.shared.updateUserName(name: userName)
        } catch {
            
        }
    }
    
    func getPollsCreatedByMe() async {
        guard madeByMePollList.isEmpty else { return }

        do {
            let polls = try await ApiManager.shared.getPollsCreatedByMe(page: madeByMePollPage, size: madeByMePollSize)
            madeByMePollList = polls.items
            madeByMePollPage += 1
        } catch {
            
        }
    }
    
    func fetchPollsCreatedByMe() async {
        if madeByMePollIsEnd { return }

        do {
            let newPolls = try await ApiManager.shared.getPollsCreatedByMe(page: madeByMePollPage, size: madeByMePollSize)
            madeByMePollPage += 1
            madeByMePollList.append(contentsOf: newPolls.items)
            madeByMePollRequestAdd = false
            
            madeByMePollIsEnd = newPolls.items.isEmpty
        } catch {
            
        }
    }
    
    func getFavoritePolls() async {
        do {
            try await ApiManager.shared.getFavoritePolls()
        } catch {
            
        }
    }
}
