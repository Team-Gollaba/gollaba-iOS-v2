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
    // 검색 필터 창을 다루는 변수
    var isFilterOpen: Bool = false
    
    // 검색어가 없을 경우 토스트를 띄우기 위해 다루는 변수
    var showSearchErrorToast: Bool = false
    
    // 검색 결과 페이지네이션을 할 때 추가로 필요할 경우 true
    var requestAddPoll: Bool = false
    
    // 검색 결과 데이터가 더 이상 없을 경우 true
    var isEnd: Bool = false
    
    // 에러 발생 시 에러 메시지를 보여주기 위한 flag
    var showErrorDialog: Bool = false
    
    //MARK: - Data
    // 검색 창의 텍스트를 관리하는 변수
    var searchText: String

    // 검색 창의 focus를 관리하는 변수
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
    
    // pollTypeFilter에 따른 enum value 값을 저장한 변수
    let pollTypeFilterText: [String] = ["", "NAMED", "ANONYMOUS"]
    
    // isActiveFilter에 따른 enum value 값을 저장한 변수
    let isActiveFilterText: [String] = ["", "ACTIVE", "INACTIVE"]
    
    // 검색 결과 페이지네이션의 페이지
    var page: Int = 0
    
    // 검색 결과 페이지네이션의 페이지 사이즈
    let pageSize: Int = 10
    
    // 검색 결과 데이터를 저장하는 변수
    var searchResultPollData: AllPollData?
    
    //MARK: - Error
    // 에러 발생 시 보여줄 메시지를 저장하는 변수
    var errorMessage: String = ""
    
    //MARK: - Initialization
    init(query: String) {
        self.searchText = query
    }
    
    //MARK: - API
    // 검색 결과를 가져오는 함수 (맨 처음 한번만 호출되는 함수)
    func getSearchResult() async {
        do {
            self.searchResultPollData = try await ApiManager.shared.getPolls(page: self.page, size: self.pageSize, optionGroup: .title, query: self.searchText)
            self.page += 1
            
            self.isEnd = self.searchResultPollData?.items.count == self.searchResultPollData?.totalCount
        } catch {
            handleError(error: error)
        }
    }
    
    // 필터에 따른 검색 결과를 가져오는 함수 (검색 버튼 혹은 필터의 적용 버튼을 클릭 했을 때 호출되는 함수)
    func getSearchResultByFilter() async {
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
    }

    // 페이지네이션에 의한 추가 데이터를 가져오는 함수
    func fetchMoreResultByFilter() async {
        if self.isEnd { return }
        
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
    }
    
    //MARK: - Check Valid
    // 검색어를 입력했는지 확인하는 함수
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
