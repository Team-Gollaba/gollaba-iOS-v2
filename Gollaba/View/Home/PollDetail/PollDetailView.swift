//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct PollDetailView: View {
    @Environment(\.dismiss) var dismiss
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
                
                if let poll = viewModel.poll, viewModel.isValidPoll {
                    if poll.responseType == ResponseType.single.rawValue {
                        PollDetailContentBySingleGridView(poll: poll, selectedPoll: $viewModel.selectedSinglePoll)
                    } else if poll.responseType == ResponseType.multiple.rawValue {
                        PollDetailContentByMultipleGridView(poll: poll, selectedPoll: $viewModel.selectedMultiplePoll)
                    }
                }
                
                PollButton(pollbuttonState: $viewModel.pollButtonState) {
                    viewModel.voting()
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
        .onAppear {
            viewModel.getPoll()
//            viewModel.readPoll()
//            viewModel.votingCheck()
        }
        .onDisappear {
            viewModel.deleteOption()
        }
    }
    
    private func formattedDate(_ date: String) -> String {
        return date.split(separator: "T").first?.replacingOccurrences(of: "-", with: ". ") ?? ""
    }
}
//
//#Preview {
//    PollDetailView(poll: PollItem(id: "1", title: "title", creatorName: "creator", responseType: "response", pollType: "poll", endAt: "", readCount: 1, totalVotingCount: 2, items: []))
//}
