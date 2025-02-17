//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import Kingfisher
import AlertToast

struct PollDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel: PollDetailViewModel
    
    init(id: String) {
        self._viewModel = State(wrappedValue: PollDetailViewModel(id: id))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 20) {
                    
                    VStack (alignment: .leading) {
                        HStack (alignment: .bottom, spacing: 0) {
                            
                            Text(viewModel.poll?.title ?? "")
                                .font(.suitBold32)
                            
                            Spacer()
                            
                            if authManager.isLoggedIn {
                                FavoritesButton(isFavorite: $viewModel.isFavorite)
                                    .onChange(of: viewModel.isFavorite) { _, newValue in
                                        Task {
                                            if newValue {
                                                await viewModel.createFavorite()
                                            } else {
                                                await viewModel.deleteFavorite()
                                            }
                                            await viewModel.getFavorite()
                                        }
                                    }
                            }
                        }
                        .skeleton(isActive: viewModel.poll == nil)
                        
                        HStack {
                            ProfileImageView(imageUrl: viewModel.poll?.creatorProfileUrl, width: 40, height: 40)
                            
                            VStack(alignment:. leading, spacing: 4) {
                                Text(viewModel.poll?.creatorName ?? "작성자")
                                    .font(.suitBold16)
                                    .foregroundStyle(.black)
                                
                                Text(formattedDate(viewModel.poll?.endAt ?? ""))
                                    .font(.suitVariable16)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "eye")
                                .padding(.leading, 12)
                            
                            Text("\(viewModel.poll?.readCount ?? -1)")
                                .font(.suitVariable16)
                        }
                        .skeleton(isActive: viewModel.poll == nil)
                        
                    }
                    
                    
                    PollTypeView(pollType: PollType(rawValue: viewModel.poll?.pollType ?? PollType.named.rawValue) ?? PollType.none, responseType: ResponseType(rawValue: viewModel.poll?.responseType ?? ResponseType.single.rawValue) ?? ResponseType.none)
                        .skeleton(isActive: viewModel.poll == nil)
                    
                    
                    if viewModel.poll?.pollType == PollType.named.rawValue && !viewModel.isVoted && viewModel.isValidDatePoll && !authManager.isLoggedIn {
                        VStack (alignment: .leading, spacing: 4) {
                            Text("닉네임 (변경 하려면 입력하세요.)")
                                .font(.suitVariable12)
                                .foregroundStyle(.pollContentTitleFont)
                            
                            ClearableTextFieldView(
                                placeholder: "기명 투표를 위해 닉네임을 입력해주세요.",
                                editText: $viewModel.inputNameText,
                                isFocused: $viewModel.inputNameFocused
                            )
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(.black, lineWidth: 1)
                            )
                        }
                        .skeleton(isActive: viewModel.poll == nil)
                    }
                    
                    
                    if let poll = viewModel.poll, viewModel.isValidDatePoll {
                        if poll.responseType == ResponseType.single.rawValue {
                            PollDetailContentBySingleGridView(poll: poll, selectedPoll: $viewModel.selectedSinglePoll, activateSelectAnimation: $viewModel.activateSelectAnimation)
                                .skeleton(isActive: viewModel.poll == nil)
                        } else if poll.responseType == ResponseType.multiple.rawValue {
                            PollDetailContentByMultipleGridView(poll: poll, selectedPoll: $viewModel.selectedMultiplePoll, activateSelectAnimation: $viewModel.activateSelectAnimation)
                                .skeleton(isActive: viewModel.poll == nil)
                        }
                    }
                    
                    HStack {
                        VotingButton(pollbuttonState: $viewModel.votingButtonState) {
                            if viewModel.checkVoting() {
                                switch viewModel.votingButtonState {
                                case .normal:
                                    Task {
                                        await viewModel.vote()
                                        await viewModel.getVotingId()
                                        await viewModel.getPoll()
                                        await viewModel.getPollVoters()
                                    }
                                case .completed:
                                    Task {
                                        await viewModel.updateVote()
                                        await viewModel.getVotingId()
                                        await viewModel.getPoll()
                                        await viewModel.getPollVoters()
                                    }
                                default:
                                    break
                                }
                            }
                        }
                        
                        VStack {
                            if authManager.isLoggedIn && viewModel.isVoted && viewModel.isValidDatePoll && !viewModel.isAnonymousVoted {
                                VotingButton(pollbuttonState: .constant(.cancel)) {
                                    viewModel.isClickedCancelButton = true
                                }
                                .transition(.move(edge: .trailing))
                            }
                        }
                        .animation(.bouncy, value: authManager.isLoggedIn && viewModel.isVoted && viewModel.isValidDatePoll)
                    }
                    .skeleton(isActive: viewModel.poll == nil)
                    
                    PollResultView(
                        totalVotingCount: viewModel.poll?.totalVotingCount ?? 0,
                        votedPeopleCount: viewModel.poll?.votedPeopleCount ?? 0,
                        pollOptions: viewModel.poll?.items ?? [],
                        isHide: !viewModel.isVoted && viewModel.isValidDatePoll,
                        onClickChart: { pollItemId in
                            guard let pollVoters = viewModel.pollVoters else { return }
                            viewModel.pollVotersTitle = viewModel.poll?.items.first(where: { $0.id == pollItemId})?.description ?? ""
                            viewModel.pollVoterNames = pollVoters.first(where: { $0.pollItemId == pollItemId })?.voterNames ?? []
                            
                            withAnimation {
                                viewModel.isPresentPollVotersView = true
                            }
                        }
                    )
                    .skeleton(isActive: viewModel.poll == nil)
                    
                    if viewModel.isVoted || !viewModel.isValidDatePoll {
                        PollRankingView(totalVotingCount: viewModel.poll?.totalVotingCount ?? 0, pollOptions: viewModel.poll?.items ?? [])
                            .skeleton(isActive: viewModel.poll == nil)
                    }
                    
                }
                .padding()
            }
            
            if viewModel.isPresentPollVotersView {
                PollVotersView(
                    isPresented: $viewModel.isPresentPollVotersView,
                    title: viewModel.pollVotersTitle,
                    voterNames: viewModel.pollVoterNames
                )
            }
            
            if viewModel.showReportDialog {
                ReportDialogView(
                    isPresented: $viewModel.showReportDialog,
                    reportType: $viewModel.reportType,
                    reportReason: $viewModel.reportReason,
                    onReport: {
                        Task {
                            await viewModel.reportPoll()
                        }
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        viewModel.showReportDialog = true
                    }
                } label: {
                    VStack {
                        Image(systemName: "exclamationmark.bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .dialog(
            isPresented: $viewModel.showAlreadyVotedAlert,
            title: "투표하기",
            content: Text("이미 투표하셨습니다. 로그인 유저만 투표 항목을 변경할 수 있습니다."),
            primaryButtonText: "확인",
            onPrimaryButton: {}
        )
        .dialog(
            isPresented: $viewModel.inValidVoteAlert,
            title: "투표하기",
            content: Text(viewModel.inValidVoteAlertContent),
            primaryButtonText: "확인",
            onPrimaryButton: {}
        )
        .dialog(
            isPresented: $viewModel.isClickedCancelButton,
            title: "투표하기",
            content: Text("투표를 취소하시겠습니까?"),
            primaryButtonText: "확인",
            secondaryButtonText: "취소",
            onPrimaryButton: {
                Task {
                    await viewModel.cancelVote()
                    await viewModel.getPoll()
                    await viewModel.votingCheck()
                    viewModel.votingIdData = nil
                    viewModel.selectedSinglePoll = nil
                    viewModel.selectedMultiplePoll = Array(repeating: false, count: viewModel.selectedMultiplePoll.count)
                    viewModel.votingButtonState = .normal
                }
            }
        )
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "투표화면",
            content: Text("\(viewModel.errorMessage)")
        )
        .toast(isPresenting: $viewModel.showCompletedReportToast, alert: {
            AlertToast(type: .complete(.enrollButton), title: "신고가 완료 되었습니다.", style: .style(titleFont: .suitBold16))
        })
        .onAppear {
            Task {
                await viewModel.readPoll()
                await viewModel.getPoll()
                await viewModel.votingCheck()
                await viewModel.getPollVoters()
                if authManager.isLoggedIn && viewModel.isVoted {
                    await viewModel.getVotingId()
                    viewModel.setSelectedPollItem()
                }
            }
            
            if authManager.isLoggedIn && authManager.favoritePolls.contains(viewModel.id) {
                viewModel.isFavorite = true
            }
            viewModel.inputNameText = viewModel.getRandomNickName()
            viewModel.setAuthManager(authManager)
            
        }
        .onDisappear {
            viewModel.deleteOption()
        }
        .onChange(of: viewModel.isVoted, { _, newValue in
            if newValue {
                Task {
                    await viewModel.getVotingId()
                }
            }
        })
        .onChange(of: viewModel.inputNameFocused, { _, newValue in
            if newValue {
                viewModel.inputNameText = ""
            }
        })
        .refreshable(action: viewModel.loadPoll)
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = inputFormatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let dateYear = calendar.component(.year, from: date)
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = (dateYear == currentYear) ? "MM월 dd일 a hh:mm" : "yyyy년 MM월 dd일 a hh:mm"
        
        return outputFormatter.string(from: date)
    }
}

#Preview {
    PollDetailView(id: "1")
        .environment(AuthManager())
    
}
