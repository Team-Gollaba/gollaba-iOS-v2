//
//  HomeViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

@Observable
class HomeViewModel {
    //MARK: - Properties
    
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
    
    //MARK: - API
    func getPolls() async {
        if let allPolls, !allPolls.items.isEmpty { return }
        
        do {
            self.allPolls = try await ApiManager.shared.getPolls(page: self.allPollsPage, size: self.allPollsSize)
            self.allPollsPage += 1
        } catch {
            handleError(error: error)
        }
    }
    
    func fetchPolls() async {
        if isAllPollsEnd { return }
        
        do {
            let newPolls = try await ApiManager.shared.getPolls(page: self.allPollsPage, size: self.allPollsSize)
            self.allPollsPage += 1
            self.allPolls?.items.append(contentsOf: newPolls.items)
            self.requestAddPoll = false
            
            self.isAllPollsEnd = newPolls.items.isEmpty
        } catch {
            handleError(error: error)
        }
    }
    
    func getTrendingPolls() async {
        if let trendingPolls, !trendingPolls.isEmpty { return }
        
        do {
            let newPolls = try await ApiManager.shared.getTrendingPolls()
            self.trendingPolls?.removeAll()
            self.trendingPolls = newPolls
        } catch {
            handleError(error: error)
        }
    }
    
    func getTopPolls() async {
        if let topPolls, !topPolls.isEmpty { return }
        
        do {
            let newPolls = try await ApiManager.shared.getTopPolls()
            self.topPolls?.removeAll()
            self.topPolls = newPolls
        } catch {
            handleError(error: error)
        }
    }
    
    @Sendable func loadEveryPolls() async {
        
        do {
            self.allPollsPage = 0
            let allPolls = try await ApiManager.shared.getPolls(page: self.allPollsPage, size: self.allPollsSize)
            let trendingPolls = try await ApiManager.shared.getTrendingPolls()
            let topPolls = try await ApiManager.shared.getTopPolls()
            self.allPollsPage += 1
            
            // 데이터를 불러오는 느낌을 주기 위해 딜레이
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            self.allPolls = allPolls
            self.trendingPolls = trendingPolls
            self.topPolls = topPolls
        } catch {
            handleError(error: error)
        }
        isScrollToTop = true
    }
    
    //MARK: - ETC
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
