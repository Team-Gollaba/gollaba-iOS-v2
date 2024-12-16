//
//  SearchViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import Foundation

@Observable
class SearchViewModel {
    var searchText: String = ""
    var searchFocus: Bool = false
    
    var isFilterOpen: Bool = false
    var madeDateFilter: [Bool] = [true, false, false]
    var pollTypeFilter: [Bool] = [true, false, false]
    var isActiveFilter: [Bool] = [true, false, false]
    var madeDateFilterText: [String] = ["", "createAt", "endAt"]
    var pollTypeFilterText: [String] = ["", "NAMED", "ANONYMOUS"]
    var isActiveFilterText: [String] = ["", "ACTIVE", "INACTIVE"]
    
    var showSearchErrorToast: Bool = false

    var page: Int = 1
    let pageSize: Int = 10
    
    var searchResultPollData: AllPollData?
    
    var requestAddPoll: Bool = false
    var isEnd: Bool = false
    
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showSearchErrorToast = true
            
            return false
        }
        
        return true
    }
    
    func getPolls() async {
        let sortIndex: Int = madeDateFilter.indices.filter { madeDateFilter[$0] }.first ?? 0
        let pollTypeIndex = pollTypeFilter.indices.filter { pollTypeFilter[$0] }.first ?? 0
        let isActiveIndex = isActiveFilter.indices.filter { isActiveFilter[$0] }.first ?? 0
        
        let sort = SortedBy(rawValue: madeDateFilterText[sortIndex])
        let pollType = PollType(rawValue: pollTypeFilterText[pollTypeIndex])
        let isActive = IsActive(rawValue: isActiveFilterText[isActiveIndex])
        
        self.page = 1
        
        do {
            searchResultPollData?.items.removeAll()
            let newPolls = try await ApiManager.shared.getPolls(
                page: page,
                size: pageSize,
                sort: sort ?? .none,
                pollType: pollType ?? .none,
                optionGroup: .title,
                query: searchText,
                isActive: isActive ?? .none
            )
            searchResultPollData = newPolls
            page += 1
            
            isEnd = searchResultPollData?.items.count == searchResultPollData?.totalCount
        } catch {
            
        }
    }
    
    func fetchMoreResult() async {
        if isEnd { return }
        
        let sortIndex: Int = madeDateFilter.indices.filter { madeDateFilter[$0] }.first ?? 0
        let pollTypeIndex = pollTypeFilter.indices.filter { pollTypeFilter[$0] }.first ?? 0
        let isActiveIndex = isActiveFilter.indices.filter { isActiveFilter[$0] }.first ?? 0
        
        let sort = SortedBy(rawValue: madeDateFilterText[sortIndex])
        let pollType = PollType(rawValue: pollTypeFilterText[pollTypeIndex])
        let isActive = IsActive(rawValue: isActiveFilterText[isActiveIndex])
        
        do {
            let newPolls = try await ApiManager.shared.getPolls(
                page: page,
                size: pageSize,
                sort: sort ?? .none,
                pollType: pollType ?? .none,
                optionGroup: .title,
                query: searchText,
                isActive: isActive ?? .none
            )
            page += 1
            searchResultPollData?.items.append(contentsOf: newPolls.items)
            requestAddPoll = false
            
            isEnd = newPolls.items.isEmpty
        } catch {
            
        }
    }
}