//
//  MyPollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

enum MyPollSelectedTab: Int {
    case madeByMe = 0
    case faovirteByMe = 1
    case participated = 2
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
    let madeByMePollSize: Int = 10
    var activateAnimation: Bool = false
    
    var favoriteByMePollList: [PollItem] = []
    var favoriteByMePollRequestAdd: Bool = false
    var favoriteByMePollIsEnd: Bool = false
    var favoriteByMePollPage: Int = 0
    let favoriteByMePollSize: Int = 10
    
    var participatedPollList: [PollItem] = []
    var participatedPollRequestAdd: Bool = false
    var participatedPollIsEnd: Bool = false
    var participatedPollPage: Int = 0
    let participatedPollSize: Int = 10
    
    var selectedTab: MyPollSelectedTab = .madeByMe
    var madeByMeTabHeight: CGFloat = 0
    var favoriteByMeTabHeight: CGFloat = 0
    var participatedTabHeight: CGFloat = 0
    var currentTabHeight: CGFloat = 0
    
    var authManager: AuthManager?
    var userData: UserData?
    var userName: String = ""
    
    var tempPolls: [PollItem] = Array(
        repeating: PollItem(
            id: "-1",
            title: "title title title",
            creatorName: "creatorName",
            creatorProfileUrl: "",
            responseType: "responseType",
            pollType: "pollType",
            endAt: "2024. 22. 22.",
            readCount: 0,
            totalVotingCount: 0,
            items: Array(
                repeating: PollOption(
                    id: 0,
                    description: "",
                    imageUrl: "",
                    votingCount: 1
                ),
                count: 2
            )
        ),
        count: 10
    )
    
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
        case .faovirteByMe:
            currentTabHeight = favoriteByMeTabHeight
        case .participated:
            currentTabHeight = participatedTabHeight
        }
        
        print("currentTabHeight: \(currentTabHeight)")
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
            authManager?.name = userName
        } catch {
            
        }
    }
    
    func updateUserName() async {
        do {
            try await ApiManager.shared.updateUserName(name: userName)
            authManager?.name = userName
        } catch {
            
        }
    }
    
    func resetPollsCreatedByMe() {
        madeByMePollList.removeAll()
        madeByMePollPage = 0
        madeByMePollIsEnd = false
    }
    
    func resetPollsFavoriteByMe() {
        favoriteByMePollList.removeAll()
        favoriteByMePollPage = 0
        favoriteByMePollIsEnd = false
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
    
    func getPollsFavoriteByMe() async {
        guard favoriteByMePollList.isEmpty else { return }
        
        do {
            let polls = try await ApiManager.shared.getPollsFavoriteByMe(page: favoriteByMePollPage, size: favoriteByMePollSize)
            favoriteByMePollList = polls.items
            favoriteByMePollPage += 1
        } catch {
            
        }
    }
    
    func fetchPollsFavoriteByMe() async {
        if favoriteByMePollIsEnd { return }
        
        do {
            let newPolls = try await ApiManager.shared.getPollsFavoriteByMe(page: favoriteByMePollPage, size: favoriteByMePollSize)
            favoriteByMePollPage += 1
            favoriteByMePollList.append(contentsOf: newPolls.items)
            favoriteByMePollRequestAdd = false
            
            favoriteByMePollIsEnd = newPolls.items.isEmpty
        } catch {
            
        }
    }
    
    func getPollsParticipated() async {
        guard participatedPollList.isEmpty else { return }
        
        do {
            let polls = try await ApiManager.shared.getPollsParticipated(page: participatedPollPage, size: participatedPollSize)
            participatedPollList = polls.items
            participatedPollPage += 1
        } catch {
            
        }
    }
    
    func fetchPollsParticipated() async {
        if participatedPollIsEnd { return }
        
        do {
            let newPolls = try await ApiManager.shared.getPollsParticipated(page: participatedPollPage, size: participatedPollSize)
            participatedPollPage += 1
            participatedPollList.append(contentsOf: newPolls.items)
            participatedPollRequestAdd = false
            
            participatedPollIsEnd = newPolls.items.isEmpty
        } catch {
            
        }
    }
    
    @Sendable func loadPolls() async {
        do {
            try await Task.sleep(nanoseconds: 1000_000_000)
            resetPollsCreatedByMe()
            resetPollsFavoriteByMe()
            await getPollsCreatedByMe()
            await getPollsFavoriteByMe()
        } catch {
            
        }
    }
    
    func createFavorite(pollHashId: String) async {
        do {
            try await ApiManager.shared.createFavoritePoll(pollHashId: pollHashId)
        } catch {
            
        }
    }
    
    func deleteFavorite(pollHashId: String) async {
        do {
            try await ApiManager.shared.deleteFavoritePoll(pollHashId: pollHashId)
        } catch {
            
        }
    }
    
    func getFavoritePolls() async {
        do {
            try await ApiManager.shared.getFavoritePolls()
        } catch {
            
        }
    }
    
    func createAppNotification() async {
        guard !AppStorageManager.shared.saveToNotificationServerSuccess else { return }
        guard let agentId = AppStorageManager.shared.agentId else {
            Logger.shared.log(String(describing: self), #function, "agentId is nil")
            return
        }
        guard let permissionForNotification = AppStorageManager.shared.permissionForNotification else {
            Logger.shared.log(String(describing: self), #function, "permissionForNotification is nil")
            return
        }
        do {
            try await ApiManager.shared.createAppPushNotification(
                agentId: agentId,
                allowsNotification: permissionForNotification
            )
        } catch {
            
        }
    }
    
    // fcm테스트용
    func sendToServerMessage(title: String, content: String) async {
        do {
            try await ApiManager.shared.sendPushNotification(title: title, content: content)
        } catch {
            
        }
    }
}
