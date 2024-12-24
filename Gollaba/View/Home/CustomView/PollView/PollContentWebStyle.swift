//
//  PollContentWebStyle.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI
import Kingfisher

struct PollContentWebStyle: View {
    var poll: PollItem
    var isHorizontal: Bool = false
    let contentWidth: CGFloat
    
    var body: some View {
        
        NavigationLink {
            PollDetailView(id: poll.id)
        } label: {
            ZStack {
                VStack (alignment: .leading, spacing: 4) {
                    HStack {
//                        if let profileImageUrl = poll.creatorProfileUrl {
//                            KFImage(URL(string: profileImageUrl))
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                        } else {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                        }
//                        
//                        Text(poll.creatorName)
//                            .font(.suitBold20)
//                        
                        
                    }
                    Text(poll.title)
                        .font(.suitBold20)
                        .overlay(
                            poll.id == "-1" ? .white : .clear
                        )
                        .overlay(
                            poll.id == "-1" ? ShimmerView() : nil
                        )
                    
                    Text("\(formattedDate(poll.endAt)). 마감")
                        .font(.suitVariable16)
                        .foregroundStyle(.myPollLikedVotes)
                        .overlay(
                            poll.id == "-1" ? .white : .clear
                        )
                        .overlay(
                            poll.id == "-1" ? ShimmerView() : nil
                        )
                        .padding(.bottom, 12)
                    
                    PollContentOptionView(options: poll.items, isHorizontal: isHorizontal, parentWidth: contentWidth)
                        .overlay(
                            poll.id == "-1" ? .white : .clear
                        )
                        .overlay(
                            poll.id == "-1" ? ShimmerView() : nil
                        )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(radius: 5)
                )
                
                VStack {
                    HStack {
                        Spacer()
                        
                        PollStateView(state: getState(poll.endAt))
                            .overlay(
                                poll.id == "-1" ? .white : .clear
                            )
                            .overlay(
                                poll.id == "-1" ? ShimmerView() : nil
                            )
                    }
                    Spacer()
                }
                .padding()
            }
            .padding(12)
        }
        .frame(width: min(contentWidth, UIScreen.main.bounds.width))
        .tint(.black)
        .disabled(poll.id == "-1")
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
    PollContentWebStyle(poll: PollItem(id: "1", title: "title", creatorName: "creator", creatorProfileUrl: "", responseType: "response", pollType: "pollType", endAt: "", readCount: 1, totalVotingCount: 1, items: []), contentWidth: .infinity)
}
