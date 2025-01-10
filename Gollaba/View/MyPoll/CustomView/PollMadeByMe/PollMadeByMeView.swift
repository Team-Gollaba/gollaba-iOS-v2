//
//  AllPollContent.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct PollMadeByMeView: View {
    let poll: PollItem
    @State var isOpen: Bool = false
    
    var body: some View {
        NavigationLink {
            PollDetailView(id: poll.id)
        } label: {
            VStack (alignment: .leading) {
                HStack (spacing: 16) {
                    Text(poll.title)
                        .font(.suitBold20)
                        .overlay(
                            poll.id == "-1" ? .white : .clear
                        )
                        .overlay(
                            poll.id == "-1" ? ShimmerView() : nil
                        )
                    
                    Spacer()
                    
                    //                PollStateView(state: state)
                    PollStateView(state: getState(poll.endAt))
                        .overlay(
                            poll.id == "-1" ? .white : .clear
                        )
                        .overlay(
                            poll.id == "-1" ? ShimmerView() : nil
                        )
                    
                    OpenAndCloseButton(isOpen: $isOpen)
                        .overlay(
                            poll.id == "-1" ? .white : .clear
                        )
                        .overlay(
                            poll.id == "-1" ? ShimmerView() : nil
                        )
                }
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                if isOpen {
                    ForEach(poll.items, id: \.self) { pollOption in
                        PollChartView(
                            title: pollOption.description,
                            allCount: poll.totalVotingCount,
                            selectedCount: pollOption.votingCount
                        )
                        
                    }
                    
                    
                    HStack {
                        Text("\(formattedDate(poll.endAt)) 마감 · 조회수 \(poll.readCount)회")
                            .font(.suitVariable16)
                            .foregroundStyle(.gray.opacity(0.7))
                        
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.white)
            .cornerRadius(10)
            .background(
                Rectangle()
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            )
            .padding(10)
        }
        .tint(.black)
    }
    
    private func formattedDate(_ date: String) -> String {
        return date.split(separator: "T").first?.replacingOccurrences(of: "-", with: ". ") ?? ""
    }
    
    func setDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    func getState(_ dateString: String) -> Bool {
        let date = setDate(dateString)
        return date > Date()
    }
}

#Preview {
    PollMadeByMeView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: "", responseType: "responseType", pollType: "pollType", endAt: "2024-12-20T12:22:33", readCount: 3, totalVotingCount: 10, items: [PollOption(id: 101, description: "desc1", imageUrl: nil, votingCount: 2), PollOption(id: 102, description: "desc2", imageUrl: nil, votingCount: 8)]))
}
