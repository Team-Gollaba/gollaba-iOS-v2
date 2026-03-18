//
//  MyPollViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

enum MyPollSelectedTab: Int {
    case createdByMe = 0
    case favoriteByMe = 1
    case participated = 2
}

@Observable
class MyPollViewModel {
    //MARK: - Properties
    private let pollsUseCase: PollsUseCaseProtocol
    private let favoriteUseCase: FavoriteUseCaseProtocol
    private let pushNotificationUseCase: PushNotificationUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    
    //MARK: - Flag
    var goToLogin: Bool = false
    var isClickedProfileImage: Bool = false
    var isClickedLogoutButton: Bool = false
    var showErrorDialog: Bool = false
    var showLogoutedDialog: Bool = false
    
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
    
    var selectedTab: MyPollSelectedTab = .createdByMe
    
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
    
    //MARK: - Initialize
    init(pollsUseCase: PollsUseCaseProtocol = PollsUseCase(), favoriteUseCase: FavoriteUseCaseProtocol = FavoriteUseCase(), pushNotificationUseCase: PushNotificationUseCaseProtocol = PushNotificationUseCase(), userUseCase: UserUseCaseProtocol = UserUseCase()) {
        self.pollsUseCase = pollsUseCase
        self.favoriteUseCase = favoriteUseCase
        self.pushNotificationUseCase = pushNotificationUseCase
        self.userUseCase = userUseCase
    }
    
    //MARK: - OAuth
    
    func logout() async {
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is nil", .error)
            return
        }
        
        authManager.logout()
        
    }
    
    //MARK: - API
    
    func getUser() async {
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is nil", .error)
            return
        }

        switch await userUseCase.getUserMe() {
        case .success(let userData):
            authManager.userData = userData
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func getPollsCreatedByMe() async {
        guard createdByMePollList.isEmpty else { return }
        guard authManager?.isLoggedIn ?? false else { return }
        
        let result = await pollsUseCase.getPollsCreatedByMe(page: self.createdByMePollPage, size: self.createdByMePollSize)
        
        switch result {
        case .success(let allPollData):
            self.createdByMePollList = allPollData.items
            self.createdByMePollPage += 1
            self.createdByMePollIsEnd = allPollData.items.count == allPollData.totalCount
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func fetchPollsCreatedByMe() async {
        if createdByMePollIsEnd { return }
        
        let result = await pollsUseCase.getPollsCreatedByMe(page: self.createdByMePollPage, size: self.createdByMePollSize)
        
        switch result {
        case .success(let allPollData):
            self.createdByMePollPage += 1
            self.createdByMePollList.append(contentsOf: allPollData.items)
            self.createdByMePollRequestAdd = false
            self.createdByMePollIsEnd = self.createdByMePollList.count == allPollData.totalCount
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func getPollsFavoriteByMe() async {
        guard favoriteByMePollList.isEmpty else { return }
        guard authManager?.isLoggedIn ?? false else { return }
        
        let result = await pollsUseCase.getPollsFavoriteByMe(page: self.favoriteByMePollPage, size: self.favoriteByMePollSize)
        
        switch result {
        case .success(let allPollData):
            self.favoriteByMePollList = allPollData.items
            self.favoriteByMePollPage += 1
            self.favoriteByMePollIsEnd = allPollData.items.count == allPollData.totalCount
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func fetchPollsFavoriteByMe() async {
        if favoriteByMePollIsEnd { return }
        
        let result = await pollsUseCase.getPollsFavoriteByMe(page: self.favoriteByMePollPage, size: self.favoriteByMePollSize)
        
        switch result {
        case .success(let allPollData):
            self.favoriteByMePollPage += 1
            self.favoriteByMePollList.append(contentsOf: allPollData.items)
            self.favoriteByMePollRequestAdd = false
            self.favoriteByMePollIsEnd = self.favoriteByMePollList.count == allPollData.totalCount
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func getPollsParticipated() async {
        guard participatedPollList.isEmpty else { return }
        guard authManager?.isLoggedIn ?? false else { return }
        
        let result = await pollsUseCase.getPollsParticipated(page: self.participatedPollPage, size: self.participatedPollSize)
        
        switch result {
        case .success(let allPollData):
            self.participatedPollList = allPollData.items
            self.participatedPollPage += 1
            self.participatedPollIsEnd = allPollData.items.count == allPollData.totalCount
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func fetchPollsParticipated() async {
        if participatedPollIsEnd { return }
        
        let result = await pollsUseCase.getPollsParticipated(page: self.participatedPollPage, size: self.participatedPollSize)
        
        switch result {
        case .success(let allPollData):
            self.participatedPollPage += 1
            self.participatedPollList.append(contentsOf: allPollData.items)
            self.participatedPollRequestAdd = false
            self.participatedPollIsEnd = self.participatedPollList.count == allPollData.totalCount
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    @Sendable func loadPolls() async {
        switch selectedTab {
        case .createdByMe:
            let existingPollPage = self.createdByMePollPage
            self.createdByMePollPage = 0
            
            let result = await pollsUseCase.getPollsCreatedByMe(page: self.createdByMePollPage, size: self.createdByMePollSize)
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            switch result {
            case .success(let allPollData):
                self.createdByMePollPage += 1
                self.createdByMePollList = allPollData.items
                self.createdByMePollIsEnd = self.createdByMePollList.count == allPollData.totalCount
            case .failure(let error):
                self.createdByMePollPage = existingPollPage
                handleError(error: error)
            }
        case .favoriteByMe:
            let existingPollPage = self.favoriteByMePollPage
            self.favoriteByMePollPage = 0
            
            let result = await pollsUseCase.getPollsFavoriteByMe(page: self.favoriteByMePollPage, size: self.favoriteByMePollSize)
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            switch result {
            case .success(let allPollData):
                self.favoriteByMePollPage += 1
                self.favoriteByMePollList = allPollData.items
                self.favoriteByMePollIsEnd = self.favoriteByMePollList.count == allPollData.totalCount
            case .failure(let error):
                self.favoriteByMePollPage = existingPollPage
                handleError(error: error)
            }
        case .participated:
            let existingPollPage = self.participatedPollPage
            self.participatedPollPage = 0
            
            let result = await pollsUseCase.getPollsParticipated(page: self.participatedPollPage, size: self.participatedPollSize)
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            switch result {
            case .success(let allPollData):
                self.participatedPollPage += 1
                self.participatedPollList = allPollData.items
                self.participatedPollIsEnd = self.participatedPollList.count == allPollData.totalCount
            case .failure(let error):
                self.participatedPollPage = existingPollPage
                handleError(error: error)
            }
        }
    }
    
    func createFavorite(pollHashId: String) async {
        let result = await favoriteUseCase.createFavoritePoll(pollHashId: pollHashId)
        
        switch result {
        case .success(()):
            break
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func deleteFavorite(pollHashId: String) async {
        let result = await favoriteUseCase.deleteFavoritePoll(pollHashId: pollHashId)
        
        switch result {
        case .success(()):
            break
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func getFavoritePolls() async {
        let result = await favoriteUseCase.getFavoritePolls()
        
        switch result {
        case .success(let favoritePolls):
            authManager?.favoritePolls = favoritePolls
        case .failure(let error):
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
        
        let result = await pushNotificationUseCase.createAppPushNotification(
            agentId: agentId,
            allowsNotification: permissionForNotification
        )
        
        switch result {
        case .success(()):
            break
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    // fcm테스트용
//    func sendToServerMessage(title: String, content: String) async {
//        do {
//            try await ApiManager.shared.sendPushNotification(title: title, content: content)
//        } catch {
//            
//        }
//    }
    
    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
    
    func updateCurrentTabHeight() {
        switch selectedTab {
        case .createdByMe:
            currentTabHeight = madeByMeTabHeight
        case .favoriteByMe:
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
    
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
