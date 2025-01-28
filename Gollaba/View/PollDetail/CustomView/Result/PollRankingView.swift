//
//  PollRankingView.swift
//  Gollaba
//
//  Created by 김견 on 11/27/24.
//

import SwiftUI

struct PollRankingView: View {
    var pollList: [Int] = Array(0...2)
    var crownImageList: [Image] = [
        Image("1st"),
        Image("2nd"),
        Image("3rd"),
    ]
    var totalVotingCount: Int
    var pollOptions: [PollOption]
    var sortedPollOptions: [PollOption] {
        pollOptions.sorted { $0.votingCount > $1.votingCount }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image("LeaderBoard")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("순위")
                    .font(.suitVariable16)
            }
            
            Divider()
                .frame(height: 1)
                .background(Color.enrollButton)
                .padding(.bottom, 8)
            
            VStack {
                ForEach(pollList, id: \.self) { poll in
                    if poll >= sortedPollOptions.count {
                        EmptyView()
                    } else {
                        HStack {
                            crownImageList[poll]
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text(sortedPollOptions[poll].description)
                                .font(.suitVariable16)
                            
                            Spacer()
                            
                            Text(getPercentage(sortedPollOptions[poll].votingCount, totalVotingCount))
                                .font(.suitVariable16)
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.toolbarBackground)
        )
    }
    
    private func getPercentage(_ count: Int, _ total: Int) -> String {
        if total == 0 {
            return "0%"
        } else {
            let percentage = (Double(count) / Double(total) * 100).rounded()
            return "\(Int(percentage))%"
        }
    }
}

#Preview {
    PollRankingView(totalVotingCount: 5, pollOptions: [])
}
