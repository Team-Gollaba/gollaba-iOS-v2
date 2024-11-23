//
//  PollContentOptionView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollContentOptionView: View {
    var options: [String]
    
    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 4) {
                ZStack {
                    Image("cocacola")
                        .resizable()
                        .scaledToFill()
                        .frame(width: (geometry.size.width - 4) / 2, height: 120)
                        .clipped()
                    
                    Text(options[0])
                        .font(.suitBold24)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                        )
                }
                
                ZStack {
                    Image("pepsi")
                        .resizable()
                        .scaledToFill()
                        .frame(width: (geometry.size.width - 4) / 2, height: 120)
                        .clipped()
                    
                    Text(options[1])
                        .font(.suitBold24)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                        )
                }
            }
            .frame(maxHeight: 120)
        }
        .frame(height: 120) // 부모 뷰의 높이를 고정
    }
}

#Preview {
    PollContentOptionView(options: ["코카콜라", "펩시"])
}

