//
//  HomeViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

@Observable
class HomeViewModel {
    var searchText: String = ""
    
    var searchFocus: Bool = false
    var goToPollDetail: Bool = false
    var requestAddPoll: Bool = false
    
    var isAllPollsEnd: Bool = false
    
    var isScrollToTop: Bool = false
    
    var showSearchErrorToast: Bool = false
    var goToSearchResult: Bool = false
    
    var allPolls: AllPollData?
    var trendingPolls: [PollItem]?
    var topPolls: [PollItem]?
    
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
    
    
    var allPollsPage: Int = 1 {
        didSet {
            print("allPollsPage: \(allPollsPage)")
        }
    }
    let allPollsSize: Int = 10
    
    //MARK: - API
    //MARK: - All polls
    func getPolls() {
        if let allPolls, !allPolls.items.isEmpty { return }
    
        Task {
            do {
                allPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
                allPollsPage += 1
    
            } catch {
                
            }
            
        }
    }
    
    func fetchPolls() {
        if isAllPollsEnd { return }
        print("fetchPolls")
        Task {
            do {
                let newPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
                allPollsPage += 1
                allPolls?.items.append(contentsOf: newPolls.items)
                requestAddPoll = false
                
                isAllPollsEnd = newPolls.items.isEmpty
            } catch {
                
            }
        }
    }
    
    //MARK: - Trending polls
    func getTrendingPolls() {
        if let trendingPolls, !trendingPolls.isEmpty { return }
        
        Task {
            do {
                trendingPolls?.removeAll()
                trendingPolls = try await ApiManager.shared.getTrendingPolls()
            } catch {
                
            }
         
        }
    }
    
    //MARK: - Top polls
    func getTopPolls() {
        if let topPolls, !topPolls.isEmpty { return }
        
        Task {
            do {
                topPolls?.removeAll()
                topPolls = try await ApiManager.shared.getTopPolls()
                
                
            } catch {

            }
            
        }
    }
    
    @Sendable func loadEveryPolls() async {
        
        do {
            allPollsPage = 1
            let allPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
            let trendingPolls = try await ApiManager.shared.getTrendingPolls()
            let topPolls = try await ApiManager.shared.getTopPolls()
            allPollsPage += 1
            try await Task.sleep(nanoseconds: 1000_000_000)
            
            self.allPolls = allPolls
            self.trendingPolls = trendingPolls
            self.topPolls = topPolls
        } catch {
            
        }
        isScrollToTop = true
    }
    
    //MARK: - Not API
    func searchPolls() {
        
    }
    
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showSearchErrorToast = true
            
            return false
        }
        
        return true
    }
}
