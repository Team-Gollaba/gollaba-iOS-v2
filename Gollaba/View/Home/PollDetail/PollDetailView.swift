//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct PollDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var poll: PollItem
    @State var viewModel: PollDetailViewModel
    
    init(poll: PollItem) {
        self._poll = State(wrappedValue: poll)
        self._viewModel = State(wrappedValue: PollDetailViewModel(poll: poll))
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
                        
                        Text(poll.title)
                            .font(.suitBold32)
                        
                    }
                    .padding(.leading, 4)
                    
                    
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                        
                        Text("\(poll.creatorName) · \(formattedDate(poll.endAt)). 마감")
                            .font(.suitVariable16)
                        
                        Spacer()
                        
                        Image(systemName: "eye")
                            .padding(.leading, 12)
                        
                        Text("\(poll.readCount)")
                            .font(.suitVariable16)
                    }
                    
                }
                
                PollTypeView(pollType: PollType(rawValue: poll.pollType) ?? PollType.none, responseType: ResponseType(rawValue: poll.responseType) ?? ResponseType.none)
                
                if viewModel.isValidPoll {
                    if poll.responseType == ResponseType.single.rawValue {
                        PollDetailContentBySingleGridView(poll: poll, selectedPoll: $viewModel.selectedSinglePoll)
                    } else if poll.responseType == ResponseType.multiple.rawValue {
                        PollDetailContentByMultipleGridView(poll: poll, selectedPoll: $viewModel.selectedMultiplePoll)
                    }
                }
                
                PollButton(pollbuttonState: $viewModel.pollButtonState)
                
                PollResultView(totalVotingCount: poll.totalVotingCount, pollOptions: poll.items)
                
                PollRankingView(totalVotingCount: poll.totalVotingCount, pollOptions: poll.items)
                
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
            viewModel.readPoll()
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
