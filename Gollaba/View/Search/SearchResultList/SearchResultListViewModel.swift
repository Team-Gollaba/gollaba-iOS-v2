//
//  SearchResultListViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/12/24.
//

import SwiftUI

@Observable
class SearchResultListViewModel {
    var searchText: String
    var searchFocused: Bool = false
    
    var isFilterOpen: Bool = false
    var pollTypeFilter: [Bool] = [true, false, false]
    var isActiveFilter: [Bool] = [true, false, false]
    var sortedBy: SortedBy = .createdAt
    var pollTypeFilterText: [String] = ["", "NAMED", "ANONYMOUS"]
    var isActiveFilterText: [String] = ["", "ACTIVE", "INACTIVE"]
    
    var showSearchErrorToast: Bool = false
    
    var page: Int = 0
    let pageSize: Int = 10
    
    var searchResultPollData: AllPollData?
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
    
    var requestAddPoll: Bool = false
    var isEnd: Bool = false
    
    init(query: String) {
        self.searchText = query
    }
    
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showSearchErrorToast = true
            
            return false
        }
        
        return true
    }
    
    func getSearchResult() async {
        do {
            searchResultPollData = try await ApiManager.shared.getPolls(page: page, size: pageSize, optionGroup: .title, query: searchText)
            page += 1
            
            isEnd = searchResultPollData?.items.count == searchResultPollData?.totalCount
        } catch {
            
        }
    }
    
    func getSearchResultByFilter() async {
        let pollTypeIndex = pollTypeFilter.indices.filter { pollTypeFilter[$0] }.first ?? 0
        let isActiveIndex = isActiveFilter.indices.filter { isActiveFilter[$0] }.first ?? 0
        
        let pollType = PollType(rawValue: pollTypeFilterText[pollTypeIndex])
        var isActive = IsActive(boolValue: isActiveFilterText[isActiveIndex] == "ACTIVE" ? true : false)
        if isActiveIndex == 0 {
            isActive = .none
        }
        
        self.page = 0
        
        do {
            searchResultPollData?.items.removeAll()
            let newPolls = try await ApiManager.shared.getPolls(
                page: page,
                size: pageSize,
                sort: sortedBy,
                pollType: pollType ?? .none,
                optionGroup: .title,
                query: searchText,
                isActive: isActive
            )
            searchResultPollData = newPolls
            page += 1
            
            isEnd = searchResultPollData?.items.count == searchResultPollData?.totalCount
        } catch {
            
        }
    }

    
    func fetchMoreResultByFilter() async {
        if isEnd { return }
        
        let pollTypeIndex = pollTypeFilter.indices.filter { pollTypeFilter[$0] }.first ?? 0
        let isActiveIndex = isActiveFilter.indices.filter { isActiveFilter[$0] }.first ?? 0
        
        let pollType = PollType(rawValue: pollTypeFilterText[pollTypeIndex])
        var isActive = IsActive(boolValue: isActiveFilterText[isActiveIndex] == "ACTIVE" ? true : false)
        if isActiveIndex == 0 {
            isActive = .none
        }
        
        do {
            let newPolls = try await ApiManager.shared.getPolls(
                page: page,
                size: pageSize,
                sort: sortedBy,
                pollType: pollType ?? .none,
                optionGroup: .title,
                query: searchText,
                isActive: isActive
            )
            searchResultPollData?.items.append(contentsOf: newPolls.items)
            page += 1
            requestAddPoll = false
            
            isEnd = newPolls.items.isEmpty
        } catch {
            
        }
        
    }
}
