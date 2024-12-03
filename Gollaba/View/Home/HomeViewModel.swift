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
    
    var allPolls: AllPollData?
    var trendingPolls: [PollItem]?
    var topPolls: [PollItem]?
    
    var tempPolls: [PollItem] = Array(
        repeating: PollItem(
            id: "-1",
            title: "title title title",
            creatorName: "creatorName",
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
    
    
    var allPollsPage: Int = 0
    let allPollsSize: Int = 10
    
    @Sendable func loadEveryPolls() async {
        
        do {
            let allPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
            let trendingPolls = try await ApiManager.shared.getTrendingPolls()
            let topPolls = try await ApiManager.shared.getTopPolls()
            try await Task.sleep(nanoseconds: 1000_000_000)
            
            self.allPolls = allPolls
            self.trendingPolls = trendingPolls
            self.topPolls = topPolls
        } catch {
            
        }
    }
    
    //MARK: - API
    //MARK: - All polls
    func getPolls() {
        if let allPolls, !allPolls.items.isEmpty { return }
    
        Task {
            do {
                
                allPollsPage = 0
                allPolls?.items.removeAll()
                allPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
                allPollsPage += 1
                print("loadEveryPolls allPolls: \(allPolls?.items.count ?? 0)")
            } catch {
                
            }
            
        }
    }
    
    func fetchPolls() {
        if isAllPollsEnd { return }
        
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
                print("loadEveryPolls trendingPolls: \(trendingPolls?.count ?? 0)")
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
                
                
                
                print("loadEveryPolls topPolls: \(topPolls?.count ?? 0)")
            } catch {

            }
            
        }
    }
}
