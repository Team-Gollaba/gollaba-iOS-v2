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
        HStack (spacing: 4) {
            ZStack {
                Image("AppIconImage")
                    .resizable()
                    .scaledToFit()
                    
                
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
                Image("AppIconImage")
                    .resizable()
                    .scaledToFit()
                    
                
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
        .frame(height: 120)
    }
}

#Preview {
    PollContentOptionView(options: ["코카콜라", "펩시"])
}
