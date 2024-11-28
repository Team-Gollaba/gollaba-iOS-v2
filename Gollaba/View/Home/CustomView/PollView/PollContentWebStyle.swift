//
//  PollContentWebStyle.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollContentWebStyle: View {
    var title: String
    var endDate: Date
    var state: Bool
    var options: [PollOption]
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                VStack (alignment: .leading) {
                    Text(title)
                        .font(.suitBold20)
                    
                    Text("\(formattedDate(endDate)). 마감")
                        .font(.suitVariable16)
                        .padding(.bottom, 12)
                    
                    PollContentOptionView(options: options)
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
                        
                        PollStateView(state: state)
                    }
                    Spacer()
                }
                .padding()
            }
            .padding(12)
        }
        .tint(.black)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
}

#Preview {
    PollContentWebStyle(title: "title", endDate: Date(), state: true, options: [], action: {})
}
