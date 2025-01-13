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
    // 비 로그인 유저가 이미 한 투표에 또 투표를 할 경우 true
    var showAlreadyVotedAlert: Bool = false
    
    // 투표를 하기 위한 검사 도중 문제가 있을 경우 true
    var inValidVoteAlert: Bool = false
    
    // 투표하기 성공 시 선택된 옵션들에 애니메이션을 주기 위한 변수
    var activateSelectAnimation: Bool = false
    
    // 로그인 유저가 투표취소 버튼을 눌렀을 경우 true
    var isClickedCancelButton: Bool = false
    
    // 기명 투표의 경우 투표 결과의 chart를 클릭할 경우 true
    var isPresentPollVotersView: Bool = false
    
    // 좋아요 상태에 따른 변수 (로그인 유저만 이용 가능)
    var isFavorite: Bool = false
    
    // 에러 발생 시 에러 메시지를 보여주기 위한 flag
    var showErrorDialog: Bool = false
    
    //MARK: - Poll Data
    // 생성자로 전달되는 해당 투표의 id 값
    var id: String
    
    // 해당 투표의 데이터
    var poll: PollItem?
    
    // 해당 투표의 투표자들에 대한 데이터
    var pollVoters: [PollVotersResponseData]?
    
    // 단일 투표를 다루기 위한 변수
    var selectedSinglePoll: Int? = nil
    
    // 복수 투표를 다루기 위한 변수
    var selectedMultiplePoll: [Bool] = []
    
    // 투표 상태를 다루기 위한 변수
    /// - PollButtonState:
    ///     - normal : 투표를 하지 않은 상태 ("투표하기" 로 표시)
    ///     - completed : 로그인 유저가 투표를 완료한 상태 ("재투표하기" 로 표시)
    ///     - ended : 이미 기한이 끝나 종료된 투표 ("이미 종료된 투표입니다." 로 표시)
    var pollButtonState: PollButtonState = .normal
    
    // 기명 투표의 경우 입력되는 이름
    var inputNameText: String = ""
    
    // inputNameText의 textField의 focus를 관리하는 변수
    var inputNameFocused: Bool = false
    
    // 투표 여부를 체크 하는 변수
    var isVoted: Bool = false {
        didSet {
            guard let authManager else { return }
            
            if isVoted && isValidDatePoll && authManager.isLoggedIn {
                pollButtonState = .completed
            }
        }
    }
    
    // 유효하지 않은 상태에서 투표를 할경우의 메세지 저장을 위한 변수
    var inValidVoteAlertContent: String = ""
    
    // 유효한 날짜인지를 다루는 변수
    var isValidDatePoll: Bool {
        get {
            if let poll {
                getState(poll.endAt)
            } else {
                false
            }
        }
    }
    
    // 투표자들이 선택한 옵션을 저장하는 변수
    var pollVotersTitle: String = ""
    
    // 투표자들의 이름을 저장하는 변수
    var pollVoterNames: [String] = []
    
    // 로그인 유저가 재투표 및 투표 철회를 하기 위해 votingId와 함께 다루는 변수
    var votingIdData: VotingIdResponseData?
    
    // 로그인 상태에서 데이터를 다루기 위한 변수
    var authManager: AuthManager?
    
    //MARK: - Error
    // 에러 발생 시 보여줄 메시지를 저장하는 변수
    var errorMessage: String = ""
    
    //MARK: - Initialization
    init(id: String) {
        self.id = id
    }
    
    //MARK: - API
    // 생성자로 전달 받은 id로 투표의 모든 데이터를 불러오는 함수
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
    
    // 조회수를 올리는 함수
    func readPoll() async {
        do {
            try await ApiManager.shared.readPoll(pollHashId: self.id)
        } catch {
            handleError(error: error)
        }
    }
    
    // 투표 진행 여부를 확인하는 함수
    func votingCheck() async {
        do {
            if let poll {
                self.isVoted = try await ApiManager.shared.votingCheck(pollHashId: poll.id)
                
                if !self.isValidDatePoll {
                    self.pollButtonState = .ended
                } else if self.isVoted && (self.authManager?.isLoggedIn ?? false) {
                    self.pollButtonState = .completed
                }
                
            } else {
                Logger.shared.log(String(describing: self), #function, "poll not found", .error)
                handleError(error: nil)
            }
        } catch {
            handleError(error: error)
        }
    }
    
    // 진행한 투표에서 votingId관련 데이터를 가져오는 함수
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
    
    // 기명 투표일 경우 투표자들을 불러오는 함수
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
    
    // 새로 고침 시 호출되는 함수
    @Sendable func loadPoll() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await getPoll()
            await votingCheck()
        } catch {
            
        }
    }
    
    // 투표를 진행하는 함수
    func vote() async {
        let pollItemIds: [Int] = getSelectedPollItemId()
        var voterName: String
        
        // 로그인 유저일 경우 이름 데이터를 가져오고 비 로그인 유저일 경우 입력창에서 받아온 데이터 사용
        if let authManager, authManager.isLoggedIn {
            voterName = authManager.name
        } else {
            voterName = inputNameText
        }
        
        do {
            if let poll {
                try await ApiManager.shared.voting(pollHashId: self.id, pollItemIds: pollItemIds, voterName: poll.pollType == PollType.named.rawValue ? voterName : nil)
                
                self.isVoted = true
                self.activateSelectAnimation = true
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
    
    // 로그인 유저가 다른 옵션으로 투표를 바꾸는 함수
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
        let voterName = authManager.name
        
        do {
            try await ApiManager.shared.updateVote(votingId: votingIdData.votingId, voterName: voterName, pollItemIds: pollItemIds)
            self.activateSelectAnimation = true
        } catch {
            handleError(error: error)
        }
    }
    
    // 로그인 유저가 투표를 철회하는 함수
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
    
    // 로그인 유저가 좋아요를 클릭하여 좋아요 항목으로 추가될 때 호출되는 함수
    func createFavorite() async {
        do {
            try await ApiManager.shared.createFavoritePoll(pollHashId: id)
        } catch {
            handleError(error: error)
        }
    }
    
    // 로그인 유저가 좋아요를 철회할 때 호출되는 함수
    func deleteFavorite() async {
        do {
            try await ApiManager.shared.deleteFavoritePoll(pollHashId: id)
        } catch {
            handleError(error: error)
        }
    }
    
    // 로그인 유저가 좋아요한 투표의 id 리스트를 가져오는 함수
    func getFavorite() async {
        do {
            try await ApiManager.shared.getFavoritePolls()
        } catch {
            handleError(error: error)
        }
    }
    
    //MARK: - check valid
    // 투표를 진행할 때 유효한지 확인하는 함수
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
    // 비 로그인 유저가 기명 투표를 할 때 자동으로 이름을 만들어주는 함수
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
    
    // 선택 된 투표들을 모두 초기화 하는 함수
    func deleteOption() {
        selectedSinglePoll = nil
        
        if let poll {
            selectedMultiplePoll = Array(repeating: false, count: poll.items.count)
        }
    }
    
    // 문자열로 된 날짜 데이터를 Date 타입으로 반환하는 함수
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
    func getSelectedPollItemId() -> [Int] {
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
    }
    
    func handleError(error: Error?) {
        self.errorMessage = "데이터를 불러오는 중에 오류가 발생하였습니다."
        self.showErrorDialog = true
    }
}
