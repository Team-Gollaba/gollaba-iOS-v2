//
//  HomeViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import Alamofire

@MainActor
@Observable
class HomeViewModel {
    //MARK: - Properties
    private let pollsUseCase: PollsUseCaseProtocol
    
    //MARK: - Flag
    var requestAddPoll: Bool = false
    var isAllPollsEnd: Bool = false
    var isScrollToTop: Bool = false
    
    var showErrorDialog: Bool = false
    
    //MARK: - Poll Data
    private(set) var allPolls: AllPollData?
    private(set) var trendingPolls: [PollItem]?
    private(set) var topPolls: [PollItem]?
    
    private var allPollsPage: Int = 0
    private let allPollsSize: Int = 10
    
    //MARK: - Error
    private(set) var errorMessage: String = ""
    
    //MARK: - Initialize
    init(pollsUseCase: PollsUseCaseProtocol = PollsUseCase()) {
        self.pollsUseCase = pollsUseCase
    }
    
    //MARK: - API
    func getPolls() async {
        if let allPolls, !allPolls.items.isEmpty { return }
        
        let result = await pollsUseCase.getPolls(page: self.allPollsPage, size: self.allPollsSize)
        
        switch result {
        case .success(let allPollData):
            self.allPolls = allPollData
            self.allPollsPage += 1
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func fetchPolls() async {
        if isAllPollsEnd { return }
        
        let result = await pollsUseCase.getPolls(page: self.allPollsPage, size: self.allPollsSize)
        
        switch result {
        case .success(let allPollData):
            self.allPollsPage += 1
            self.allPolls?.items.append(contentsOf: allPollData.items)
            self.requestAddPoll = false
            self.isAllPollsEnd = allPollData.items.isEmpty
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func getTrendingPolls() async {
        if let trendingPolls, !trendingPolls.isEmpty { return }
        
        let result = await pollsUseCase.getTrendingPolls()
        
        switch result {
        case .success(let trendingPolls):
            self.trendingPolls?.removeAll()
            self.trendingPolls = trendingPolls
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    func getTopPolls() async {
        if let topPolls, !topPolls.isEmpty { return }
        
        let result = await pollsUseCase.getTopPolls()
        
        switch result {
        case .success(let topPolls):
            self.topPolls?.removeAll()
            self.topPolls = topPolls
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    @Sendable func loadEveryPolls() async {
        let existingPollsPage = self.allPollsPage
        self.allPollsPage = 0
        let allPollsResult = await pollsUseCase.getPolls(page: self.allPollsPage, size: self.allPollsSize)
        let trendingPollsResult = await pollsUseCase.getTrendingPolls()
        let topPollsResult = await pollsUseCase.getTopPolls()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        switch allPollsResult {
        case .success(let allPollData):
            self.allPollsPage += 1
            self.allPolls = allPollData
        case .failure(let error):
            self.allPollsPage = existingPollsPage
            handleError(error: error)
        }
        
        switch trendingPollsResult {
        case .success(let trendingPolls):
            self.trendingPolls = trendingPolls
        case .failure(let error):
            handleError(error: error)
        }
        
        switch topPollsResult {
        case .success(let topPolls):
            self.topPolls = topPolls
        case .failure(let error):
            handleError(error: error)
        }
        
        isScrollToTop = true
    }
    
    //MARK: - ETC
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
