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
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .skeleton(isActive: poll.id == "-1")
                    
                    Spacer()
                    
                    PollStateView(state: getState(poll.endAt))
                        .skeleton(isActive: poll.id == "-1")
                    
                    FavoritesButton(isFavorite: $isFavorite)
                        .onChange(of: isFavorite) { _, newValue in
                            onFavorite(newValue)
                        }
                        .skeleton(isActive: poll.id == "-1")
                }
                
                HStack {
                    ProfileImageView(imageUrl: poll.creatorProfileUrl, width: 24, height: 24)
                    
                    Text("\(poll.creatorName)")
                        .font(.suitBold16)
                        .foregroundStyle(.gray.opacity(0.7))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .skeleton(isActive: poll.id == "-1")
                
                Text("\(formattedDate(poll.endAt)) · 조회수 \(poll.readCount)회")
                    .font(.suitVariable16)
                    .foregroundStyle(.gray.opacity(0.7))
                    .skeleton(isActive: poll.id == "-1")
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
        .disabled(poll.id == "-1")
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        guard let date = formatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let dateYear = calendar.component(.year, from: date)
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = (dateYear == currentYear) ? "MM월 dd일 a hh:mm" : "yyyy년 MM월 dd일 a hh:mm"
        
        return outputFormatter.string(from: date)
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
    PollFavoriteByMeView(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: nil, responseType: "responseType", pollType: "pollType", endAt: "2024-12-20T12:22:33", readCount: 5, votedPeopleCount: 1, totalVotingCount: 10, items: [
        PollOption(id: 101, description: "desc1", imageUrl: nil, votingCount: 3),
        PollOption(id: 102, description: "desc2", imageUrl: nil, votingCount: 7)
    ]), isFavorite: false, onFavorite: { _ in })
}
