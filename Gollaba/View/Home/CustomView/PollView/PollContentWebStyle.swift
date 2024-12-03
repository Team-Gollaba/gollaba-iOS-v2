//
//  PollContentWebStyle.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollContentWebStyle: View {
    var poll: PollItem
    var isHorizontal: Bool = false
    var isLoading: Bool
    
    var body: some View {
        
        NavigationLink {
            PollDetailView(id: poll.id)
        } label: {
            ZStack {
                VStack (alignment: .leading, spacing: 4) {
                    Text(poll.title)
                        .font(.suitBold20)
                        .overlay(
                            isLoading ? .white : .clear
                        )
                        .overlay(
                            isLoading ? ShimmerView() : nil
                        )
                    
                    Text("\(formattedDate(poll.endAt)). 마감")
                        .font(.suitVariable16)
                        .overlay(
                            isLoading ? .white : .clear
                        )
                        .overlay(
                            isLoading ? ShimmerView() : nil
                        )
                        .padding(.bottom, 12)
                    
                    PollContentOptionView(options: poll.items, isHorizontal: isHorizontal)
                        .overlay(
                            isLoading ? .white : .clear
                        )
                        .overlay(
                            isLoading ? ShimmerView() : nil
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
                                isLoading ? .white : .clear
                            )
                            .overlay(
                                isLoading ? ShimmerView() : nil
                            )
                    }
                    Spacer()
                }
                .padding()
            }
            .padding(12)
        }
        .tint(.black)
        .disabled(isLoading)
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
    PollContentWebStyle(poll: PollItem(id: "1", title: "title", creatorName: "creator", responseType: "response", pollType: "pollType", endAt: "", readCount: 1, totalVotingCount: 1, items: []), isLoading: true)
}
