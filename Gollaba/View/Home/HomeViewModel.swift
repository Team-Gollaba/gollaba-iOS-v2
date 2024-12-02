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
    var isTrendingLoading: Bool = false
    var isTopLoading: Bool = false
    
    var allPolls: AllPollData?
    var trendingPolls: [PollItem]?
    var topPolls: [PollItem]?
    
    var tempPolls: [PollItem] = Array(
        repeating: PollItem(
            id: "1",
            title: "title title title",
            creatorName: "creatorName",
            responseType: "responseType",
            pollType: "pollType",
            endAt: "2024. 11. 22",
            readCount: 0,
            totalVotingCount: 0,
            items: Array(
                repeating: PollOption(
                    id: 0,
                    description: "description",
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
    
    //MARK: - API
    //MARK: - All polls
    func getPolls() {
//        if let allPolls, !allPolls.items.isEmpty { return }
        
        Task {
            do {
                allPollsPage = 0
                allPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
                allPollsPage += 1
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
        isTrendingLoading = true
        Task {
            do {
                trendingPolls = try await ApiManager.shared.getTrendingPolls()
                
            } catch {
                
            }
        }
        isTrendingLoading = false || trendingPolls?.isEmpty ?? true
    }
    
    //MARK: - Top polls
    func getTopPolls() {
        isTopLoading = true
        
        Task {
            do {
                topPolls = try await ApiManager.shared.getTopPolls()
                
            } catch {
                
            }
        }
        isTopLoading = false || topPolls?.isEmpty ?? true
    }
}
