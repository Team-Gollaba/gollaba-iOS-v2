//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import Kingfisher

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
                        HStack (spacing: 12) {
                            Image(systemName: "arrowtriangle.forward.fill")
                                .resizable()
                                .foregroundStyle(.enrollButton)
                                .frame(width: 16, height: 28)
                            
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
                        .padding(.leading, 4)
                        .skeleton(isActive: viewModel.poll == nil)
                        
                        HStack {
                            ProfileImageView(imageUrl: viewModel.poll?.creatorProfileUrl, width: 24, height: 24)
                            
                            Text("\(viewModel.poll?.creatorName ?? "작성자") · \(formattedDate(viewModel.poll?.endAt ?? Date().toString())). 마감")
                                .font(.suitVariable16)
                            
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
                        PollButton(pollbuttonState: $viewModel.pollButtonState) {
                            switch viewModel.pollButtonState {
                            case .normal:
                                if viewModel.checkVoting() {
                                    Task {
                                        await viewModel.vote()
                                        await viewModel.getVotingId()
                                        await viewModel.getPoll()
                                        await viewModel.getPollVoters()
                                    }
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                            case .completed:
                                if viewModel.checkVoting() {
                                    Task {
                                        await viewModel.updateVote()
                                        await viewModel.getVotingId()
                                        await viewModel.getPoll()
                                        await viewModel.getPollVoters()
                                    }
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                            default:
                                break
                            }
                            
                        }
                        
                        if authManager.isLoggedIn && viewModel.isVoted && viewModel.isValidDatePoll {
                            PollCancelButton {
                                viewModel.isClickedCancelButton = true
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                            .animation(.bouncy, value: viewModel.isVoted)
                        }
                    }
                    .skeleton(isActive: viewModel.poll == nil)
                    
                    PollResultView(
                        totalVotingCount: viewModel.poll?.totalVotingCount ?? 0,
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
                    viewModel.pollButtonState = .normal
                }
            }
        )
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "투표화면",
            content: Text("\(viewModel.errorMessage)")
        )
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
    
    private func formattedDate(_ date: String) -> String {
        return date.split(separator: "T").first?.replacingOccurrences(of: "-", with: ". ") ?? ""
    }
}
//
//#Preview {
//    PollDetailView(poll: PollItem(id: "1", title: "title", creatorName: "creator", responseType: "response", pollType: "poll", endAt: "", readCount: 1, totalVotingCount: 2, items: []))
//}
