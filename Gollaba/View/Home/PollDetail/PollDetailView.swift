//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI
import Kingfisher

struct PollDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) var authManager
    var id: String
    @State var viewModel: PollDetailViewModel
    
    init(id: String) {
        self.id = id
        self._viewModel = State(wrappedValue: PollDetailViewModel(id: id))
    }
    
    
    var body: some View {
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
                    .overlay(
                        viewModel.poll == nil ? .white : .clear
                    )
                    .overlay(
                        viewModel.poll == nil ? ShimmerView() : nil
                    )
                    
                    HStack {
                        if let creatorProfileUrl = viewModel.poll?.creatorProfileUrl {
                            KFImage(URL(string: creatorProfileUrl))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("\(viewModel.poll?.creatorName ?? "작성자") · \(formattedDate(viewModel.poll?.endAt ?? Date().toString())). 마감")
                            .font(.suitVariable16)
                        
                        Spacer()
                        
                        Image(systemName: "eye")
                            .padding(.leading, 12)
                        
                        Text("\(viewModel.poll?.readCount ?? -1)")
                            .font(.suitVariable16)
                    }
                    .overlay(
                        viewModel.poll == nil ? .white : .clear
                    )
                    .overlay(
                        viewModel.poll == nil ? ShimmerView() : nil
                    )
                    
                }
                
                
                PollTypeView(pollType: PollType(rawValue: viewModel.poll?.pollType ?? PollType.named.rawValue) ?? PollType.none, responseType: ResponseType(rawValue: viewModel.poll?.responseType ?? ResponseType.single.rawValue) ?? ResponseType.none)
                    .overlay(
                        viewModel.poll == nil ? .white : .clear
                    )
                    .overlay(
                        viewModel.poll == nil ? ShimmerView() : nil
                    )
                
                
                if viewModel.poll?.pollType == PollType.named.rawValue && !authManager.isLoggedIn {
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
                    .overlay(
                        viewModel.poll == nil ? .white : .clear
                    )
                    .overlay(
                        viewModel.poll == nil ? ShimmerView() : nil
                    )
                }
                
                
                if let poll = viewModel.poll, viewModel.isValidDatePoll {
                    if poll.responseType == ResponseType.single.rawValue {
                        PollDetailContentBySingleGridView(poll: poll, selectedPoll: $viewModel.selectedSinglePoll)
                            .overlay(
                                viewModel.poll == nil ? .white : .clear
                            )
                            .overlay(
                                viewModel.poll == nil ? ShimmerView() : nil
                            )
                    } else if poll.responseType == ResponseType.multiple.rawValue {
                        PollDetailContentByMultipleGridView(poll: poll, selectedPoll: $viewModel.selectedMultiplePoll)
                            .overlay(
                                viewModel.poll == nil ? .white : .clear
                            )
                            .overlay(
                                viewModel.poll == nil ? ShimmerView() : nil
                            )
                    }
                }
                
                PollButton(pollbuttonState: $viewModel.pollButtonState) {
                    if viewModel.isCompletedVoting() {
                        Task {
                            await viewModel.voting()
                        }
                    }
                }
                .overlay(
                    viewModel.poll == nil ? .white : .clear
                )
                .overlay(
                    viewModel.poll == nil ? ShimmerView() : nil
                )
                
                PollResultView(totalVotingCount: viewModel.poll?.totalVotingCount ?? 0, pollOptions: viewModel.poll?.items ?? [], isHide: !viewModel.isVoted && viewModel.isValidDatePoll)
                    .overlay(
                        viewModel.poll == nil ? .white : .clear
                    )
                    .overlay(
                        viewModel.poll == nil ? ShimmerView() : nil
                    )
                
                if viewModel.isVoted || !viewModel.isValidDatePoll {
                    PollRankingView(totalVotingCount: viewModel.poll?.totalVotingCount ?? 0, pollOptions: viewModel.poll?.items ?? [])
                        .overlay(
                            viewModel.poll == nil ? .white : .clear
                        )
                        .overlay(
                            viewModel.poll == nil ? ShimmerView() : nil
                        )
                }
                
            }
            .padding()
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
        .onAppear {
            Task {
                await viewModel.readPoll()
                await viewModel.getPoll()
                await viewModel.votingCheck()
            }
            viewModel.inputNameText = viewModel.getRandomNickName()
            
            if authManager.isLoggedIn && authManager.favoritePolls.contains(viewModel.id) {
                viewModel.isFavorite = true
            }
        }
        .onDisappear {
            viewModel.deleteOption()
        }
        .onChange(of: viewModel.isVoted) { oldValue, newValue in
            if newValue {
                Task {
                    await viewModel.getPoll()
                }
            }
        }
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
