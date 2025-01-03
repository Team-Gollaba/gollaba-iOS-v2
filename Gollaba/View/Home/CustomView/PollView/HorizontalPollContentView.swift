//
//  HorizontalPollContentView.swift
//  Gollaba
//
//  Created by 김견 on 12/31/24.
//

import SwiftUI
import Kingfisher

struct HorizontalPollContentView: View {
    var poll: PollItem
    let contentWidth: CGFloat
    
    var body: some View {
        NavigationLink {
            PollDetailView(id: poll.id)
        } label: {
            VStack (alignment: .leading, spacing: 12) {
                HStack {
                    ForEach(poll.items.prefix(2), id: \.id) { pollItem in
                        PollContentOptionItemView(
                            imageUrl: pollItem.imageUrl,
                            title: pollItem.description,
                            parentWidth: contentWidth
                        )
                    }
                    
//                    if poll.items.count > 2 {
//                        Image(systemName: "ellipsis")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 32, height: 32)
//                            .foregroundColor(.gray)
//                    }
                }
                
                HStack (alignment: .top, spacing: 12) {
                    Group {
                        if let profileImageUrl = poll.creatorProfileUrl {
                            KFImage(URL(string: profileImageUrl))
                                .resizable()
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                    }
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(poll.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(poll.creatorName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("조회수 \(poll.readCount)회 · \(poll.totalVotingCount)명 참여")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text("\(formattedDate(poll.endAt)). 마감")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
                
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .shadow(radius: 5)
            )
        }
        .frame(width: min(contentWidth, UIScreen.main.bounds.width))
        .tint(.black)
        .disabled(poll.id == "-1")
        .padding(.vertical, 8)
    }
    
    private func formattedDate(_ date: String) -> String {
        return date.split(separator: "T").first?.replacingOccurrences(of: "-", with: ". ") ?? ""
    }
}

#Preview {
    HorizontalPollContentView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: nil, responseType: "response", pollType: "pollType", endAt: "2024-01-01", readCount: 1, totalVotingCount: 1, items: [PollOption(id: 1, description: "description", imageUrl: nil, votingCount: 2)]), contentWidth: .infinity)
}
