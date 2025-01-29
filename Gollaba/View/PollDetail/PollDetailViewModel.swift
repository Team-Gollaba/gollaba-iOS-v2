//
//  PollDetailViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import SwiftUI

@Observable
class PollDetailViewModel {
    //MARK: - Properties
    
    //MARK: - Flag
    var showAlreadyVotedAlert: Bool = false
    var inValidVoteAlert: Bool = false
    var activateSelectAnimation: Bool = false
    var isClickedCancelButton: Bool = false
    var isPresentPollVotersView: Bool = false
    var isFavorite: Bool = false
    var showErrorDialog: Bool = false
    
    //MARK: - Poll Data
    let id: String
    private(set) var poll: PollItem?
    private(set) var pollVoters: [PollVotersResponseData]?
    var selectedSinglePoll: Int? = nil {
        didSet {
            if self.votingButtonState == .ended { return }
            guard let selectedSinglePoll = self.selectedSinglePoll else { return }
            let selectedItemIds = self.poll?.items[selectedSinglePoll - 1].id ?? 0
                        
            if let votingIdData = self.votingIdData {
                if votingIdData.votedItemIds.contains(selectedItemIds) {
                    self.votingButtonState = .notChanged
                } else {
                    self.votingButtonState = .completed
                }
            }
        }
    }
    var selectedMultiplePoll: [Bool] = [] {
        didSet {
            if self.votingButtonState == .ended { return }
            
            guard let votingIdData = self.votingIdData,
                  let pollItems = self.poll?.items else { return }
            
            for (index, item) in pollItems.enumerated() {
                if votingIdData.votedItemIds.contains(item.id) != self.selectedMultiplePoll[index] {
                    self.votingButtonState = .completed
                    return
                }
            }
            
            self.votingButtonState = .notChanged
        }
    }
    
    // 투표 상태를 다루기 위한 변수
    /// - PollButtonState:
    ///     - normal : 투표를 하지 않은 상태 ("투표하기" 로 표시)
    ///     - completed : 로그인 유저가 투표를 완료한 상태 ("재투표하기" 로 표시)
    ///     - ended : 이미 기한이 끝나 종료된 투표 ("이미 종료된 투표입니다." 로 표시)
    ///     - notChanged : 기존에 했던 투표와 같을 경우 ("재투표하기" 로 표시)
    var votingButtonState: VotingButtonState = .normal
    
    var inputNameText: String = ""
    var inputNameFocused: Bool = false
    
    private(set) var isVoted: Bool = false {
        didSet {
            guard let authManager else { return }
            
            if isVoted && isValidDatePoll && authManager.isLoggedIn {
                votingButtonState = .completed
            }
        }
    }
    
    private(set) var inValidVoteAlertContent: String = ""
    var isValidDatePoll: Bool {
        get {
            if let poll {
                getState(poll.endAt)
            } else {
                false
            }
        }
    }
    
    var pollVotersTitle: String = ""
    var pollVoterNames: [String] = []
    
    var votingIdData: VotingIdResponseData?
    
    private var authManager: AuthManager?
    
    //MARK: - Error
    private(set) var errorMessage: String = ""
    
    //MARK: - Initialization
    init(id: String) {
        self.id = id
    }
    
    //MARK: - API
    func getPoll() async {
        do {
            let newPoll = try await ApiManager.shared.getPoll(pollHashId: self.id)
            self.poll = newPoll
            
            if let poll {
                if self.selectedMultiplePoll.isEmpty {
                    self.selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
                }
                
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
                handleError(error: nil)
            }
        } catch {
            handleError(error: error)
        }
        
    }
    
    func readPoll() async {
        do {
            try await ApiManager.shared.readPoll(pollHashId: self.id)
        } catch {
            handleError(error: error)
        }
    }
    
    func votingCheck() async {
        do {
            if let poll {
                self.isVoted = try await ApiManager.shared.votingCheck(pollHashId: poll.id)
                
                if !self.isValidDatePoll {
                    self.votingButtonState = .ended
                } else if self.isVoted {
                    if self.authManager?.isLoggedIn ?? false {
                        self.votingButtonState = .completed
                    } else {
                        self.votingButtonState = .alreadyVoted
                    }
                }
                
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
                handleError(error: nil)
            }
        } catch {
            handleError(error: error)
        }
    }
    
    func getVotingId() async {
        guard authManager?.isLoggedIn ?? false else { return }
        
        do {
            if let poll {
                self.votingIdData = try await ApiManager.shared.getVotingIdByPollHashId(pollHashId: poll.id)
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
                handleError(error: nil)
            }
        } catch {
            handleError(error: error)
        }
    }
    
    func getPollVoters() async {
        
        do {
            if let poll {
                guard poll.pollType == PollType.named.rawValue else { return }
                self.pollVoters = try await ApiManager.shared.getVoters(pollHashId: poll.id)
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
                handleError(error: nil)
            }
        } catch {
            handleError(error: error)
        }
    }
    
    @Sendable func loadPoll() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await getPoll()
            await votingCheck()
        } catch {
            
        }
    }
    
    func vote() async {
        let pollItemIds: [Int] = getSelectedPollItemId()
        var voterName: String
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is Nil", .error)
            return
        }
        // 로그인 유저일 경우 이름 데이터를 가져오고 비 로그인 유저일 경우 입력창에서 받아온 데이터 사용
        if authManager.isLoggedIn {
            voterName = authManager.userData?.name ?? ""
        } else {
            voterName = inputNameText
        }
        
        do {
            if let poll {
                try await ApiManager.shared.voting(pollHashId: self.id, pollItemIds: pollItemIds, voterName: poll.pollType == PollType.named.rawValue ? voterName : nil)
                
                self.isVoted = true
                self.activateSelectAnimation = true
                
                if authManager.isLoggedIn {
                    self.votingButtonState = .notChanged
                } else {
                    self.votingButtonState = .alreadyVoted
                }
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
                handleError(error: nil)
            }
        } catch {
            if let votingError = error as? VotingError, votingError == VotingError.alreadyVoted {
                self.showAlreadyVotedAlert = true
            } else {
                handleError(error: error)
            }
        }
    }
    
    func updateVote() async {
        guard let authManager else {
            Logger.shared.log(String(describing: self), #function, "authManager is nil")
            handleError(error: nil)
            return
        }
        guard let votingIdData else {
            Logger.shared.log(String(describing: self), #function, "votingIdData is nil")
            handleError(error: nil)
            return
        }
        let pollItemIds: [Int] = getSelectedPollItemId()
        let voterName = authManager.userData?.name ?? ""
        
        do {
            try await ApiManager.shared.updateVote(votingId: votingIdData.votingId, voterName: voterName, pollItemIds: pollItemIds)
            self.activateSelectAnimation = true
            self.votingButtonState = .notChanged
        } catch {
            handleError(error: error)
        }
    }
    
    func cancelVote() async {
        guard let votingIdData else {
            Logger.shared.log(String(describing: self), #function, "votingIdData is nil")
            handleError(error: nil)
            return
        }
        
        do {
            try await ApiManager.shared.cancelVote(votingId: votingIdData.votingId)
        } catch {
            handleError(error: error)
        }
    }
    
    func createFavorite() async {
        do {
            try await ApiManager.shared.createFavoritePoll(pollHashId: id)
        } catch {
            handleError(error: error)
        }
    }
    
    func deleteFavorite() async {
        do {
            try await ApiManager.shared.deleteFavoritePoll(pollHashId: id)
        } catch {
            handleError(error: error)
        }
    }
    
    func getFavorite() async {
        do {
            try await ApiManager.shared.getFavoritePolls()
        } catch {
            handleError(error: error)
        }
    }
    
    //MARK: - check valid
    func checkVoting() -> Bool {
        guard let authManager else {
            return false
        }
        
        if !authManager.isLoggedIn && isVoted {
            self.showAlreadyVotedAlert = true
            return false
        }
        
        guard votingIdData?.votedItemIds.sorted() != getSelectedPollItemId().sorted() else {
            return false
        }
        
        if let poll {
            if poll.pollType == PollType.named.rawValue && inputNameText.isEmpty {
                self.inValidVoteAlertContent = "닉네임을 입력해주세요."
                self.inValidVoteAlert = true
                
                return false
            } else if poll.responseType == ResponseType.single.rawValue && selectedSinglePoll == nil {
                self.inValidVoteAlertContent = "투표를 선택해주세요."
                self.inValidVoteAlert = true
                
                return false
            } else if poll.responseType == ResponseType.multiple.rawValue && !selectedMultiplePoll.contains(true) {
                self.inValidVoteAlertContent = "투표를 선택해주세요. (최소 1개)"
                self.inValidVoteAlert = true
                
                return false
            } else {
                return true
            }
        } else {
            self.inValidVoteAlertContent = "데이터 오류입니다."
            self.inValidVoteAlert = true
            
            return false
        }
    }
    
    //MARK: - ETC
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
    
    func getRandomNickName() -> String {
        let frontNickname = [
            "뽀짝", "몽글", "쪼꼬", "졸귀", "포동", "귀염", "깜찍", "말랑", "도톰", "보들",
            "쫑긋", "쭈굴", "몽실", "포슬", "뭉실", "꼬물", "살랑", "아기", "졸깃", "솜사탕",
            "통통", "둥실", "반짝", "톡톡", "몽글몽글", "꼬맹이", "방실", "야옹", "냥냥", "쫀득"
        ]
        let backNickname = [
            "토끼", "다람쥐", "햄스터", "고양이", "강아지", "펭귄", "곰돌이", "여우", "병아리", "오리",
            "호랑이", "판다", "수달", "앵무새", "치타", "돌고래", "너구리", "삵", "코끼리", "사자",
            "도마뱀", "새우", "꽃게", "두더지", "얼룩말", "라쿤", "까마귀", "참새", "호박벌", "말미잘"
        ]
        
        return (frontNickname.randomElement() ?? "") + (backNickname.randomElement() ?? "")
    }
    
    func deleteOption() {
        selectedSinglePoll = nil
        
        if let poll {
            selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
        }
    }
    
    private func setDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    // 현재 날짜 기준으로 해당 날짜가 과거인지 미래인지 체크하는 함수
    /// - Return:
    ///     - true : 미래
    ///     - false : 과거
    private func getState(_ dateString: String) -> Bool {
        let date = setDate(dateString)
        return date > Date()
    }
    
    // 현재 선택된 옵션(들)의 pollItemId를 반환하는 함수
    private func getSelectedPollItemId() -> [Int] {
        var pollItemIds: [Int] = []
        
        if let poll {
            if poll.responseType == ResponseType.single.rawValue, let selectedPollItemIndex = self.selectedSinglePoll {
                pollItemIds.append(poll.items[selectedPollItemIndex - 1].id)
            } else if poll.responseType == ResponseType.multiple.rawValue {
                for (index, selectedPollItemId) in self.selectedMultiplePoll.enumerated() {
                    if selectedPollItemId {
                        pollItemIds.append(poll.items[index].id)
                    }
                }
            }
        } else {
            
        }
        
        return pollItemIds
    }
    
    // 서버에서 받아온 내가 투표한 항목들을 가져오는 함수
    func setSelectedPollItem() {
        guard let poll else {
            Logger.shared.log(String(describing: self), #function, "poll is nil")
            handleError(error: nil)
            return
        }
        guard let votingIdData else {
            Logger.shared.log(String(describing: self), #function, "votingIdData is nil")
            handleError(error: nil)
            return
        }
        
        switch poll.responseType {
        case ResponseType.single.rawValue:
            self.selectedSinglePoll = (poll.items.firstIndex(where: { $0.id == votingIdData.votedItemIds.first }) ?? 0) + 1
            
        case ResponseType.multiple.rawValue:
            poll.items.enumerated().forEach { index, item in
                self.selectedMultiplePoll[index] = votingIdData.votedItemIds.contains(item.id)
            }
            
        default:
            break
        }
        
        if self.votingButtonState != .ended {
            self.votingButtonState = .notChanged
        }
    }
    
    func handleError(error: Error?) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
