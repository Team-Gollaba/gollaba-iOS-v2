//
//  PollResultView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollResultView: View {
    var body: some View {
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

            PollChartView(title: "코카콜라 - 75.0%", allCount: 100, selectedCount: 75)
            PollChartView(title: "펩시 - 25.0%", allCount: 100, selectedCount: 25)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.pollResult)
        )
    }
}

#Preview {
    PollResultView()
}
