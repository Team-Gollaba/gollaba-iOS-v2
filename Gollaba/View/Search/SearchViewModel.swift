//
//  SearchViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/16/24.
//

import Foundation
import SwiftData

@Observable
class SearchViewModel {
    var searchText: String = ""
    var searchFocus: Bool = false
    
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
    var recentKeywords: [SearchKeyword]?
    var recommendedKeywords: [TrendingSearchResponseData] = []
    var whenGetToRecommendedKeywords: Date?
    
    var requestAddPoll: Bool = false
    var isEnd: Bool = false
    
    var goToSearchResult: Bool = false
    
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showSearchErrorToast = true
            
            return false
        }
        
        return true
    }
    
    //MARK: - API
    func getTrendingKeywords() async {
        do {
            recommendedKeywords = try await ApiManager.shared.getTrendingSearchKeywords()
            whenGetToRecommendedKeywords = Date()
        } catch {
            
        }
    }
    
    //MARK: - SwiftData
    func saveKeyword(_ keyword: String, context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<SearchKeyword>()
        let existingKeyword = try? context.fetch(fetchDescriptor).first(where: { $0.keyword == keyword })
        
        if let existingKeyword = existingKeyword {
            existingKeyword.timeStamp = Date()
            Logger.shared.log(String(describing: self), #function, "Updated keyword timestamp: \(keyword)")
        } else {
            let newKeyword = SearchKeyword(keyword: keyword, timeStamp: Date())
            context.insert(newKeyword)
            Logger.shared.log(String(describing: self), #function, "Added new keyword: \(keyword)")
        }
        
        do {
            try context.save()
        } catch {
            Logger.shared.log(String(describing: self), #function, "Failed to save keyword with error: \(error)", .error)
        }
    }
    
    func deleteKeyword(_ keyword: String, context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<SearchKeyword>()
        
        do {
            let keywords = try context.fetch(fetchDescriptor)
            
            if let keywordToDelete = keywords.first(where: { $0.keyword == keyword }) {
                context.delete(keywordToDelete)
            }
            
            try context.save()
        } catch {
            
        }
    }
    
    func deleteAllKeywords(context: ModelContext) {
        do {
            let allKeywords = try context.fetch(FetchDescriptor<SearchKeyword>())
            allKeywords.forEach { context.delete($0) }
            
            try context.save()
            Logger.shared.log(String(describing: self), #function, "Success to delete all keywords")
        } catch {
            Logger.shared.log(String(describing: self), #function, "Failed to delete all keywords with error: \(error)", .error)
        }
    }
}
