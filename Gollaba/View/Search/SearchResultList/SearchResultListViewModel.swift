//
//  SearchResultListViewModel.swift
//  Gollaba
//
//  Created by 김견 on 12/12/24.
//

import SwiftUI

@Observable
class SearchResultListViewModel {
    //MARK: - Properties
    
    //MARK: - Flag
    var isFilterOpen: Bool = false
    
    var showKeywordEmptyErrorToast: Bool = false
    
    var requestAddPoll: Bool = false
    var isEnd: Bool = false
    
    var showErrorDialog: Bool = false
    
    var isLoading: Bool = false
    
    //MARK: - Data
    var searchText: String
    var searchFocused: Bool = false
    
    // 기명/익명 여부를 다루는 변수
    /// - [0] : 선택 안 함
    /// - [1] : 기명
    /// - [2] : 익명
    var pollTypeFilter: [Bool] = [true, false, false]
    
    // 투표의 진행 여부를 다루는 변수
    /// - [0] : 선택 안 함
    /// - [1] : 진행중
    /// - [2] : 종료
    var isActiveFilter: [Bool] = [true, false, false]
    
    // 정렬 기준을 다루는 변수
    /// - SortedBy:
    ///     - createdAt : "생성 날짜 순"
    ///     - endAt : "마감 날짜 순"
    var sortedBy: SortedBy = .createdAt
    
    private let pollTypeFilterText: [String] = ["", "NAMED", "ANONYMOUS"]
    private let isActiveFilterText: [String] = ["", "ACTIVE", "INACTIVE"]
    
    private var page: Int = 0
    private let pageSize: Int = 10
    
    private(set) var searchResultPollData: AllPollData?
    
    //MARK: - Error
    private(set) var errorMessage: String = ""
    
    //MARK: - Initialization
    init(query: String) {
        self.searchText = query
    }
    
    //MARK: - API
    func getSearchResult() async {
        self.isLoading = true
        
        do {
            self.searchResultPollData = try await ApiManager.shared.getPolls(page: self.page, size: self.pageSize, optionGroup: .title, query: self.searchText)
            self.page += 1
            
            self.isEnd = self.searchResultPollData?.items.count == self.searchResultPollData?.totalCount
        } catch {
            handleError(error: error)
        }
        
        self.isLoading = false
    }
    
    func getSearchResultByFilter() async {
        self.isLoading = true
        
        let pollTypeIndex = self.pollTypeFilter.indices.filter { self.pollTypeFilter[$0] }.first ?? 0
        let isActiveIndex = self.isActiveFilter.indices.filter { self.isActiveFilter[$0] }.first ?? 0
        
        let pollType = PollType(rawValue: self.pollTypeFilterText[pollTypeIndex])
        var isActive = IsActive(boolValue: self.isActiveFilterText[isActiveIndex] == "ACTIVE" ? true : false)
        if isActiveIndex == 0 {
            isActive = .none
        }
        
        self.page = 0
        
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
            self.searchResultPollData?.items.removeAll()
            self.searchResultPollData = newPolls
            self.page += 1
            
            self.isEnd = self.searchResultPollData?.items.count == self.searchResultPollData?.totalCount
        } catch {
            handleError(error: error)
        }
        
        self.isLoading = false
    }

    func fetchMoreResultByFilter() async {
        if self.isEnd { return }
        self.isLoading = true
        
        let pollTypeIndex = self.pollTypeFilter.indices.filter { self.pollTypeFilter[$0] }.first ?? 0
        let isActiveIndex = self.isActiveFilter.indices.filter { self.isActiveFilter[$0] }.first ?? 0
        
        let pollType = PollType(rawValue: self.pollTypeFilterText[pollTypeIndex])
        var isActive = IsActive(boolValue: self.isActiveFilterText[isActiveIndex] == "ACTIVE" ? true : false)
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
            self.searchResultPollData?.items.append(contentsOf: newPolls.items)
            self.page += 1
            self.requestAddPoll = false
            
            self.isEnd = newPolls.items.isEmpty
        } catch {
            handleError(error: error)
        }
        
        self.isLoading = false
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
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        
        if let apiError = error as? ApiError {
            switch apiError {
            case .serverError(let message):
                self.errorMessage = message
            default:
                break
            }
        }
        self.showErrorDialog = true
    }
}
