//
//  PollRankingView.swift
//  Gollaba
//
//  Created by 김견 on 11/27/24.
//

import SwiftUI

struct PollRankingView: View {
    var pollList: [Int] = Array(1...3)
    var crownImageList: [Image] = [
        Image("1st"),
        Image("2nd"),
        Image("3rd"),
    ]
    var nameList: [String] = ["코카콜라", "펩시", "환타"]
    var ratioList: [String] = ["70.0%", "20.0%", "10.0%"]
    
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
                    HStack {
                        crownImageList[poll - 1]
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text(nameList[poll - 1])
                            .font(.suitVariable16)
                        
                        Spacer()
                        
                        Text(ratioList[poll - 1])
                            .font(.suitVariable16)
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.toolbarBackground)
        )
    }
}

#Preview {
    PollRankingView()
}
