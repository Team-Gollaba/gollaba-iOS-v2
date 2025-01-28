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
    
    let onClickChart: (Int) -> Void
    
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
                    
                    Text("\(totalVotingCount)명 참여")
                        .font(.suitBold16)
                        .foregroundStyle(.gray)
                }
                
                ForEach(pollOptions, id: \.self) { pollOption in
                    PollChartView(
                        title: "\(pollOption.description) - \(getPercentage(pollOption.votingCount, totalVotingCount))",
                        allCount: totalVotingCount,
                        selectedCount: pollOption.votingCount
                    )
                    .onTapGesture {
                        onClickChart(pollOption.id)
                    }
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
                VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .padding(.bottom, 10)
                        
                        Text("투표에 참여하고\n결과를 확인해보세요!")
                            .font(.suitBold20)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                        
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.toolbarBackground)
//                            .stroke(.enrollButton, lineWidth: 1)
                    )
                    .padding()
            }
        }
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
    PollResultView(totalVotingCount: 10, pollOptions: [], isHide: true, onClickChart: { _ in})
}
