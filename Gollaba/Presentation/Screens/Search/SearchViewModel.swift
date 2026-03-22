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
    //MARK: - Properties
    private let pollsUseCase: PollsUseCaseProtocol
    
    //MARK: - Flag
    var showKeywordEmptyErrorToast: Bool = false
    var goToSearchResult: Bool = false
    var showErrorDialog: Bool = false
    
    //MARK: - Data
    var searchText: String = ""
    var searchFocus: Bool = false
    
    var recentKeywords: [SearchKeyword] = []
    
    var trendingKeywords: [TrendingSearchResponseData] = []
    private(set) var whenGetToRecommendedKeywords: Date?
    
    //MARK: - Error
    private(set) var errorMessage: String = ""
    
    //MARK: - Initialize
    init(pollsUseCase: PollsUseCaseProtocol) {
        self.pollsUseCase = pollsUseCase
    }
    
    //MARK: - API
    func getTrendingKeywords() async {
        let result = await pollsUseCase.getTrendingSearchKeywords()
        
        switch result {
        case .success(let trendingKeywords):
            self.trendingKeywords = trendingKeywords
            self.whenGetToRecommendedKeywords = Date()
        case .failure(let error):
            handleError(error: error)
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
            Logger.shared.log(String(describing: self), #function, "Failed to delete keyword with error: \(error)", .error)
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
    
    //MARK: - Check Valid
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showKeywordEmptyErrorToast = true
            
            return false
        }
        
        return true
    }
    
    //MARK: - ETC
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
