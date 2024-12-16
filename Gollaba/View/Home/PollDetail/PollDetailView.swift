//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct PollDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(KakaoAuthManager.self) var kakaoAuthManager
    var id: String
    @State var viewModel: PollDetailViewModel
    
    init(id: String) {
        self.id = id
        self._viewModel = State(wrappedValue: PollDetailViewModel(id: id))
    }
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 28) {
                
                VStack (alignment: .leading) {
                    HStack (spacing: 12) {
                        Image(systemName: "arrowtriangle.forward.fill")
                            .resizable()
                            .foregroundStyle(.enrollButton)
                            .frame(width: 16, height: 28)
                        
                        Text(viewModel.poll?.title ?? "")
                            .font(.suitBold32)
                        
                    }
                    .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                        
                        Text("\(viewModel.poll?.creatorName ?? "작성자") · \(formattedDate(viewModel.poll?.endAt ?? Date().toString())). 마감")
                            .font(.suitVariable16)
                        
                        Spacer()
                        
                        Image(systemName: "eye")
                            .padding(.leading, 12)
                        
                        Text("\(viewModel.poll?.readCount ?? -1)")
                            .font(.suitVariable16)
                    }
                    
                }
                
                PollTypeView(pollType: PollType(rawValue: viewModel.poll?.pollType ?? PollType.named.rawValue) ?? PollType.none, responseType: ResponseType(rawValue: viewModel.poll?.responseType ?? ResponseType.single.rawValue) ?? ResponseType.none)
                
                if viewModel.poll?.pollType == PollType.named.rawValue && !kakaoAuthManager.isLoggedIn {
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
                
                if let poll = viewModel.poll, viewModel.isValidDatePoll {
                    if poll.responseType == ResponseType.single.rawValue {
                        PollDetailContentBySingleGridView(poll: poll, selectedPoll: $viewModel.selectedSinglePoll)
                    } else if poll.responseType == ResponseType.multiple.rawValue {
                        PollDetailContentByMultipleGridView(poll: poll, selectedPoll: $viewModel.selectedMultiplePoll)
                    }
                }
                
                PollButton(pollbuttonState: $viewModel.pollButtonState) {
                    if viewModel.isCompletedVoting() {
                        Task {
                            await viewModel.voting()
                        }
                    }
                }
                
                PollResultView(totalVotingCount: viewModel.poll?.totalVotingCount ?? 0, pollOptions: viewModel.poll?.items ?? [])
                
                PollRankingView(totalVotingCount: viewModel.poll?.totalVotingCount ?? 0, pollOptions: viewModel.poll?.items ?? [])
                
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
