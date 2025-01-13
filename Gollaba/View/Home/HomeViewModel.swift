//
//  HomeViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

@Observable
class HomeViewModel {
    //MARK: - Properties
    
    //MARK: - Flag
    // All Polls의 스크롤이 끝에 도달 했을 때 true
    var requestAddPoll: Bool = false
    
    // All Polls의 fetch api 호출을 다루기 위한 끝에 도달 했는지 체크하는 변수
    var isAllPollsEnd: Bool = false
    
    // 홈 화면에서 하단 탭뷰의 홈 탭을 눌렀을 때 true
    var isScrollToTop: Bool = false
    
    // 에러 발생 시 에러 메시지를 보여주기 위한 flag
    var showErrorDialog: Bool = false
    
    //MARK: - Poll Data
    // verticalList로 보여지는 모든 투표 리스트
    var allPolls: AllPollData?
    
    // 오늘의 투표 리스트
    var trendingPolls: [PollItem]?
    
    // 인기 투표 리스트
    var topPolls: [PollItem]?
    
    // 모든 투표 리스트의 페이지네이션 할 때의 페이지
    var allPollsPage: Int = 0
    
    // 모든 투표 리스트의 페이지네이션 페이지 사이즈
    let allPollsSize: Int = 10
    
    //MARK: - Error
    // 에러 발생 시 보여줄 메시지를 저장하는 변수
    var errorMessage: String = ""
    
    //MARK: - API
    // 모든 투표 리스트를 불러오는 함수
    func getPolls() async {
        if let allPolls, !allPolls.items.isEmpty { return }
        
        do {
            self.allPolls = try await ApiManager.shared.getPolls(page: self.allPollsPage, size: self.allPollsSize)
            self.allPollsPage += 1
        } catch {
            handleError(error: error)
        }
    }
    
    // 모든 투표 리스트를 추가로 불러오는 함수
    func fetchPolls() async {
        if isAllPollsEnd { return }
        
        do {
            let newPolls = try await ApiManager.shared.getPolls(page: self.allPollsPage, size: self.allPollsSize)
            self.allPollsPage += 1
            self.allPolls?.items.append(contentsOf: newPolls.items)
            self.requestAddPoll = false
            
            self.isAllPollsEnd = newPolls.items.isEmpty
        } catch {
            handleError(error: error)
        }
    }
    
    // 오늘의 투표 리스트를 불러오는 함수
    func getTrendingPolls() async {
        if let trendingPolls, !trendingPolls.isEmpty { return }
        
        do {
            let newPolls = try await ApiManager.shared.getTrendingPolls()
            self.trendingPolls?.removeAll()
            self.trendingPolls = newPolls
        } catch {
            handleError(error: error)
        }
    }
    
    // 인기 투표 리스트를 불러오는 함수
    func getTopPolls() async {
        if let topPolls, !topPolls.isEmpty { return }
        
        do {
            let newPolls = try await ApiManager.shared.getTopPolls()
            self.topPolls?.removeAll()
            self.topPolls = newPolls
        } catch {
            handleError(error: error)
        }
    }
    
    // 새로 고침 시 호출되는 함수
    @Sendable func loadEveryPolls() async {
        
        do {
            self.allPollsPage = 0
            let allPolls = try await ApiManager.shared.getPolls(page: self.allPollsPage, size: self.allPollsSize)
            let trendingPolls = try await ApiManager.shared.getTrendingPolls()
            let topPolls = try await ApiManager.shared.getTopPolls()
            self.allPollsPage += 1
            
            // 데이터를 불러오는 느낌을 주기 위해 딜레이
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            self.allPolls = allPolls
            self.trendingPolls = trendingPolls
            self.topPolls = topPolls
        } catch {
            handleError(error: error)
        }
        isScrollToTop = true
    }
    
    //MARK: - ETC
    func handleError(error: Error) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
