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
    
    //MARK: - Flag
    // 키워드 없이 검색 버튼을 눌렀을 경우 true
    var showSearchErrorToast: Bool = false
    
    // 검색 결과 화면으로 이동 하기 위한 변수
    var goToSearchResult: Bool = false
    
    // 에러 발생 시 에러 메시지를 보여주기 위한 flag
    var showErrorDialog: Bool = false
    
    //MARK: - Data
    // 검색 창의 텍스트를 관리하는 변수
    var searchText: String = ""
    
    // 검색 창의 focus를 관리하는 변수
    var searchFocus: Bool = false
    
    // 최근 검색어를 저장하는 변수
    var recentKeywords: [SearchKeyword] = []
    
    // 서버에서 받아온 인기 검색어를 저장하는 변수
    var recommendedKeywords: [TrendingSearchResponseData] = []
    
    // 인기 검색어의 갱신 시간을 저장하는 함수
    var whenGetToRecommendedKeywords: Date?
    
    //MARK: - Error
    // 에러 발생 시 보여줄 메시지를 저장하는 변수
    var errorMessage: String = ""
    
    //MARK: - API
    // 인기 검색어를 불러오는 함수
    func getTrendingKeywords() async {
        do {
            self.recommendedKeywords = try await ApiManager.shared.getTrendingSearchKeywords()
            self.whenGetToRecommendedKeywords = Date()
        } catch {
            handleError(error: error)
        }
    }
    
    //MARK: - SwiftData
    // 검색한 검색어를 swiftData에 저장하는 함수
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
    
    // swiftData에 저장된 검색어를 지우는 함수
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
    
    // swiftData에 저장된 모든 검색어를 지우는 함수
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
    // 검색창이 비어있는지 확인하는 함수
    func isValidSearchText() -> Bool {
        if searchText.isEmpty {
            self.showSearchErrorToast = true
            
            return false
        }
        
        return true
    }
    
    //MARK: - ETC
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
