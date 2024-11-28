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
    
    var allPolls: AllPollData?
    var trendingPolls: [PollItem]?
    var topPolls: [PollItem]?
    
    var allPollsPage: Int = 0
    let allPollsSize: Int = 10
    
    //MARK: - API
    //MARK: - All polls
    func getPolls() {
        Task {
            do {
                allPolls = try await ApiManager.shared.getPolls(page: allPollsPage, size: allPollsSize)
                allPollsPage += 1
            } catch {
                
            }
        }
    }
    
    func fetchPolls() {
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
        Task {
            do {
                trendingPolls = try await ApiManager.shared.getTrendingPolls()
            } catch {
                
            }
        }
    }
    
    //MARK: - Top polls
    func getTopPolls() {
        Task {
            do {
                topPolls = try await ApiManager.shared.getTopPolls()
            } catch {
                
            }
        }
    }
}
