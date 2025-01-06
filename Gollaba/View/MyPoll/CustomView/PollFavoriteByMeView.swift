//
//  PollFavoriteByMeView.swift
//  Gollaba
//
//  Created by 김견 on 1/6/25.
//

import SwiftUI

struct PollFavoriteByMeView: View {
    let poll: PollItem
    @State var isFavorite: Bool
    var onFavorite: ((Bool) -> Void)
    
    var body: some View {
        NavigationLink {
            PollDetailView(id: poll.id)
        } label: {
            VStack (alignment: .leading, spacing: 12) {
                HStack (spacing: 16) {
                    Text(poll.title)
                        .font(.suitBold20)
                    
                    Spacer()
                    
                    PollStateView(state: getState(poll.endAt))
                    
                    FavoritesButton(isFavorite: $isFavorite)
                        .onChange(of: isFavorite) { _, newValue in
                            onFavorite(newValue)
                        }
                }
                
                Text("\(formattedDate(poll.endAt)) 마감 · 조회수 \(poll.readCount)회")
                    .font(.suitVariable16)
                    .foregroundStyle(.gray.opacity(0.7))
                
                HStack {
                    ProfileImageView(imageUrl: poll.creatorProfileUrl) {
                        
                    }
                    .frame(width: 24, height: 24)
                    
                    Text("\(poll.creatorName)")
                        .font(.suitBold16)
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
    PollFavoriteByMeView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: nil, responseType: "responseType", pollType: "pollType", endAt: "2024-12-20T12:22:33", readCount: 5, totalVotingCount: 10, items: [
        PollOption(id: 101, description: "desc1", imageUrl: nil, votingCount: 3),
        PollOption(id: 102, description: "desc2", imageUrl: nil, votingCount: 7)
    ]), isFavorite: false, onFavorite: { _ in })
}
