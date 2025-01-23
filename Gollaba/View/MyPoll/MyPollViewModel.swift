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
    //MARK: - Properties
    
    //MARK: - Flag
    var goToLogin: Bool = false
    var isClickedProfileImage: Bool = false
    var isClickedLogoutButton: Bool = false
    var showErrorDialog: Bool = false
    
    //MARK: - Data
    // 내가 만든 투표
    private(set) var createdByMePollList: [PollItem] = []
    var createdByMePollRequestAdd: Bool = false
    var createdByMePollIsEnd: Bool = false
    private var createdByMePollPage: Int = 0
    private let createdByMePollSize: Int = 10
    
    // 좋아요 한 투표
    private(set) var favoriteByMePollList: [PollItem] = []
    var favoriteByMePollRequestAdd: Bool = false
    var favoriteByMePollIsEnd: Bool = false
    private var favoriteByMePollPage: Int = 0
    private let favoriteByMePollSize: Int = 10
    
    // 참여한 투표
    private(set) var participatedPollList: [PollItem] = []
    var participatedPollRequestAdd: Bool = false
    var participatedPollIsEnd: Bool = false
    private var participatedPollPage: Int = 0
    private let participatedPollSize: Int = 10
    
    var selectedTab: MyPollSelectedTab = .madeByMe
    
    var madeByMeTabHeight: CGFloat = 0
    var favoriteByMeTabHeight: CGFloat = 0
    var participatedTabHeight: CGFloat = 0
    var currentTabHeight: CGFloat = 300
    
    var authManager: AuthManager?
    
    var name: String {
        get {
            authManager?.userData?.name ?? ""
        }
        set {
            authManager?.userData?.name = newValue
        }
    }
    
    private(set) var errorMessage: String = ""
    
    //MARK: - OAuth
    
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
    
    //MARK: - API
    
    func getUser() async {
        do {
            authManager?.userData = try await ApiManager.shared.getUserMe()
            
        } catch {
            handleError(error: error)
        }
    }
    
    func updateUserName() async {
        do {
//            try await ApiManager.shared.updateUserName(name: userName)
//            authManager?.userData?.name = userName
        } catch {
            handleError(error: error)
        }
    }
    
    func getPollsCreatedByMe() async {
        guard createdByMePollList.isEmpty else { return }

        do {
            let polls = try await ApiManager.shared.getPollsCreatedByMe(page: createdByMePollPage, size: createdByMePollSize)
            createdByMePollList = polls.items
            createdByMePollPage += 1
            createdByMePollIsEnd = polls.items.count == polls.totalCount
        } catch {
            handleError(error: error)
        }
    }
    
    func fetchPollsCreatedByMe() async {
        if createdByMePollIsEnd { return }

        do {
            let newPolls = try await ApiManager.shared.getPollsCreatedByMe(page: createdByMePollPage, size: createdByMePollSize)
            createdByMePollPage += 1
            createdByMePollList.append(contentsOf: newPolls.items)
            createdByMePollRequestAdd = false
            
            createdByMePollIsEnd = newPolls.items.isEmpty
        } catch {
            handleError(error: error)
        }
    }
    
    func getPollsFavoriteByMe() async {
        guard favoriteByMePollList.isEmpty else { return }
        
        do {
            let polls = try await ApiManager.shared.getPollsFavoriteByMe(page: favoriteByMePollPage, size: favoriteByMePollSize)
            favoriteByMePollList = polls.items
            favoriteByMePollPage += 1
            favoriteByMePollIsEnd = polls.items.count == polls.totalCount
        } catch {
            handleError(error: error)
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
            handleError(error: error)
        }
    }
    
    func getPollsParticipated() async {
        guard participatedPollList.isEmpty else { return }
        
        do {
            let polls = try await ApiManager.shared.getPollsParticipated(page: participatedPollPage, size: participatedPollSize)
            participatedPollList = polls.items
            participatedPollPage += 1
            participatedPollIsEnd = polls.items.count == polls.totalCount
            
        } catch {
            handleError(error: error)
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
            handleError(error: error)
        }
    }
    
    @Sendable func loadPolls() async {
        do {
            try await Task.sleep(nanoseconds: 1000_000_000)
            resetPollsCreatedByMe()
            resetPollsFavoriteByMe()
            resetPollsParticipated()
            await getPollsCreatedByMe()
            await getPollsFavoriteByMe()
            await getPollsParticipated()
        } catch {
            handleError(error: error)
        }
    }
    
    func createFavorite(pollHashId: String) async {
        do {
            try await ApiManager.shared.createFavoritePoll(pollHashId: pollHashId)
        } catch {
            handleError(error: error)
        }
    }
    
    func deleteFavorite(pollHashId: String) async {
        do {
            try await ApiManager.shared.deleteFavoritePoll(pollHashId: pollHashId)
        } catch {
            handleError(error: error)
        }
    }
    
    func getFavoritePolls() async {
        do {
            try await ApiManager.shared.getFavoritePolls()
        } catch {
            handleError(error: error)
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
            handleError(error: error)
        }
    }
    
    // fcm테스트용
    func sendToServerMessage(title: String, content: String) async {
        do {
            try await ApiManager.shared.sendPushNotification(title: title, content: content)
        } catch {
            
        }
    }
    
    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
    
    func updateCurrentTabHeight() {
        switch selectedTab {
        case .madeByMe:
            currentTabHeight = madeByMeTabHeight
        case .faovirteByMe:
            currentTabHeight = favoriteByMeTabHeight
        case .participated:
            currentTabHeight = participatedTabHeight
        }
        
        Logger.shared.log(String(describing: self), #function, "currentTabHeight: \(currentTabHeight)")
    }
    
    func resetPollsCreatedByMe() {
        createdByMePollList.removeAll()
        createdByMePollPage = 0
        createdByMePollIsEnd = false
    }
    
    func resetPollsFavoriteByMe() {
        favoriteByMePollList.removeAll()
        favoriteByMePollPage = 0
        favoriteByMePollIsEnd = false
    }
    
    func resetPollsParticipated() {
        participatedPollList.removeAll()
        participatedPollPage = 0
        participatedPollIsEnd = false
    }
    
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
