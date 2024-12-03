//
//  PollContentOptionItemView.swift
//  Gollaba
//
//  Created by 김견 on 11/28/24.
//

import SwiftUI
import Kingfisher

struct PollContentOptionItemView: View {
    var imageUrl: String?
    var title: String
    let parentWidth: CGFloat
    
    var body: some View {
        ZStack {
            if let imageUrl {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        ShimmerView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: parentWidth / 2 - 32)
                    .frame(height: 120)
                    .clipped()
            }
            
            Text(title)
                .font(.suitBold24)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                )
        }
        .frame(height: 120)
    }
}

#Preview {
    PollContentOptionItemView(title: "title", parentWidth: .infinity)
}
