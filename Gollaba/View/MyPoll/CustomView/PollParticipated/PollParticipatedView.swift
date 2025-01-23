//
//  PollParticipatedView.swift
//  Gollaba
//
//  Created by 김견 on 1/10/25.
//

import SwiftUI

struct PollParticipatedView: View {
    let poll: PollItem
    @State var isOpen: Bool = false
    
    var body: some View {
        NavigationLink {
            PollDetailView(id: poll.id)
        } label: {
            VStack (alignment: .leading, spacing: 16) {
                HStack (spacing: 16) {
                    Text(poll.title)
                        .font(.suitBold20)
                        .skeleton(isActive: poll.id == "-1")
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    PollStateView(state: getState(poll.endAt))
                        .skeleton(isActive: poll.id == "-1")
                    
                    OpenAndCloseButton(isOpen: $isOpen)
                        .skeleton(isActive: poll.id == "-1")
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
                        ProfileImageView(imageUrl: poll.creatorProfileUrl, width: 24, height: 24)
                        
                        Text("\(poll.creatorName)")
                            .font(.suitBold16)
                            .foregroundStyle(.gray.opacity(0.7))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                    
                    Text("\(formattedDate(poll.endAt)) 마감 · 조회수 \(poll.readCount)회")
                        .font(.suitVariable16)
                        .foregroundStyle(.gray.opacity(0.7))
                        
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
    PollParticipatedView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: nil, responseType: "", pollType: "", endAt: "2026-01-10T12:34:56", readCount: 2, totalVotingCount: 10, items: [PollOption(id: 101, description: "desc1", imageUrl: nil, votingCount: 3), PollOption(id: 102, description: "desc2", imageUrl: nil, votingCount: 7)]))
}
