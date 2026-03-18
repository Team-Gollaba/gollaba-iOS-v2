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
    private let pollsUseCase: PollsUseCaseProtocol
    
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
    init(query: String, pollsUseCase: PollsUseCaseProtocol = PollsUseCase()) {
        self.searchText = query
        self.pollsUseCase = pollsUseCase
    }
    
    //MARK: - API
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
        
        let result = await pollsUseCase.getPolls(
            page: self.page,
            size: self.pageSize,
            sort: self.sortedBy,
            pollType: pollType ?? .none,
            optionGroup: .title,
            query: self.searchText,
            isActive: isActive
        )
        
        switch result {
        case .success(let allPollData):
            self.searchResultPollData?.items.removeAll()
            self.searchResultPollData = allPollData
            self.page += 1
            self.isEnd = self.searchResultPollData?.items.count == self.searchResultPollData?.totalCount
        case .failure(let error):
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
        
        let result = await pollsUseCase.getPolls(
            page: self.page,
            size: self.pageSize,
            sort: self.sortedBy,
            pollType: pollType ?? .none,
            optionGroup: .title,
            query: self.searchText,
            isActive: isActive
        )
        
        switch result {
        case .success(let allPollData):
            self.searchResultPollData?.items.append(contentsOf: allPollData.items)
            self.page += 1
            self.requestAddPoll = false
            self.isEnd = allPollData.items.isEmpty
        case .failure(let error):
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
    func handleError(error: NetworkError) {
        self.errorMessage = error.description
        self.showErrorDialog = true
    }
}
