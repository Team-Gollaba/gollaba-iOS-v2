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
            VStack (alignment: .leading) {
                HStack (spacing: 12) {
                    if let profileImageUrl = poll.creatorProfileUrl {
                        KFImage(URL(string: profileImageUrl))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    VStack (alignment: .leading) {
                        Text(poll.creatorName)
                            .font(.suitBold16)
                        
                        Text("\(formattedDate(poll.endAt)). 마감")
                            .font(.suitVariable16)
                    }
                }
                
                Text(poll.title)
                    .font(.suitBold24)
                    .overlay(
                        poll.id == "-1" ? .white : .clear
                    )
                    .overlay(
                        poll.id == "-1" ? ShimmerView() : nil
                    )
                    .padding(.bottom, 8)
                HStack {
                    ForEach(Array(poll.items.enumerated()), id: \.element.id) { index, item in
                        
                        if let imageUrl = item.imageUrl {
                            Text(item.description)
                                .font(.suitVariable16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    KFImage(URL(string: imageUrl))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                        .cornerRadius(10)
                                )
                        } else {
                            Text(item.description)
                                .font(.suitVariable16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 40)
                                        .foregroundStyle(.gray)
                                    
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Spacer()
                    
                    Text("\(poll.totalVotingCount)명 참여")
                        .font(.suitBold12)
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
        .padding()
    }
    
    private func formattedDate(_ date: String) -> String {
        return date.split(separator: "T").first?.replacingOccurrences(of: "-", with: ". ") ?? ""
    }
}

#Preview {
    HorizontalPollContentView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: nil, responseType: "response", pollType: "pollType", endAt: "2024-01-01", readCount: 1, totalVotingCount: 1, items: [PollOption(id: 1, description: "description", imageUrl: nil, votingCount: 2)]), contentWidth: .infinity)
}
