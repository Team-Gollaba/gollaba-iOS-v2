//
//  PollResultView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollResultView: View {
    var totalVotingCount: Int
    var pollOptions: [PollOption]
    var isHide: Bool
    
    var body: some View {
        ZStack {
            VStack (spacing: 10) {
                HStack (spacing: 12) {
                    Image(systemName: "arrowtriangle.forward.fill")
                        .resizable()
                        .foregroundStyle(.enrollButton)
                        .frame(width: 12, height: 24)
                    
                    Text("투표 결과")
                        .font(.suitBold24)
                    
                    Spacer()
                }
                
                ForEach(pollOptions, id: \.self) { pollOption in
                    PollChartView(title: "\(pollOption.description) - \(getPercentage(pollOption.votingCount, totalVotingCount))", allCount: totalVotingCount, selectedCount: pollOption.votingCount)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.pollResult)
            )
            .blur(radius: isHide ? 8 : 0)
            
            if isHide {
                Text("투표에 참여하고 결과를 확인해보세요!")
                    .font(.suitBold20)
                    .foregroundStyle(.pollButton)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.toolbarBackground)
                    )
            }
        }
    }
    
    private func getPercentage(_ count: Int, _ total: Int) -> String {
        if total == 0 {
            return "0.0%"
        } else {
            return String(format: "%.1f%%", Double(count) / Double(total) * 100)
        }
    }
}

#Preview {
    PollResultView(totalVotingCount: 10, pollOptions: [], isHide: true)
}
