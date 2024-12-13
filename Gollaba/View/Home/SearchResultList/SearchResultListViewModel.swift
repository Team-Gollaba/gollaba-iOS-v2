//
//  SearchResultListViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/12/24.
//

import SwiftUI

@Observable
class SearchResultListViewModel {
    let query: String
    var page: Int = 1
    let pageSize: Int = 10
    
    var searchResultPollData: AllPollData?
    
    var requestAddPoll: Bool = false
    var isEnd: Bool = false
    
    init(query: String) {
        self.query = query
    }
    
    func getSearchResult() async {
        do {
            searchResultPollData = try await ApiManager.shared.getPolls(page: page, size: pageSize, optionGroup: .title, query: query)
            page += 1
            
            isEnd = searchResultPollData?.items.count == searchResultPollData?.totalCount
        } catch {
            
        }
    }
    
    func fetchMoreResult() async {
        if isEnd { return }
        
        do {
            let newPolls = try await ApiManager.shared.getPolls(page: page, size: pageSize, optionGroup: .title, query: query)
            page += 1
            searchResultPollData?.items.append(contentsOf: newPolls.items)
            requestAddPoll = false
            
            isEnd = newPolls.items.isEmpty
        } catch {
            
        }
    }
}
