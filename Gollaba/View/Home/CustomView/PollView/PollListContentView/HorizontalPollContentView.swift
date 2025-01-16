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
            ZStack (alignment: .topTrailing) {
                VStack (alignment: .leading, spacing: 12) {
                    HStack {
                        ForEach(poll.items.prefix(2), id: \.id) { pollItem in
                            PollContentOptionItemView(
                                imageUrl: pollItem.imageUrl,
                                title: pollItem.description,
                                parentWidth: contentWidth
                            )
                        }

                    }
                    .skeleton(isActive: poll.id == "-1")
                    
                    HStack (alignment: .top, spacing: 12) {
                        ProfileImageView(imageUrl: poll.creatorProfileUrl) {
                            
                        }
                        .frame(width: 40, height: 40)
                        .skeleton(isActive: poll.id == "-1")
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(poll.title)
                                .font(.headline)
                                .foregroundColor(.black)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .skeleton(isActive: poll.id == "-1")
                            
                            Text(poll.creatorName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .skeleton(isActive: poll.id == "-1")
                            
                            Text("조회수 \(poll.readCount)회 · \(poll.totalVotingCount)명 참여")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .skeleton(isActive: poll.id == "-1")
                            
                            Text("\(formattedDate(poll.endAt)). 마감")
                                .font(.footnote)
                                .foregroundColor(.red)
                                .skeleton(isActive: poll.id == "-1")
                        }
                    }
                    
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(radius: 5)
                )
                
                PollStateViewRibbonStyle(state: getState(poll.endAt))
                    .opacity(poll.id == "-1" ? 0 : 1)
                
            }
        }
        .frame(width: min(contentWidth, UIScreen.main.bounds.width))
        .tint(.black)
        .disabled(poll.id == "-1")
        .padding(.vertical, 8)
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
    HorizontalPollContentView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: nil, responseType: "response", pollType: "pollType", endAt: "2024-01-01", readCount: 1, totalVotingCount: 1, items: [PollOption(id: 1, description: "description", imageUrl: nil, votingCount: 2)]), contentWidth: .infinity)
}
