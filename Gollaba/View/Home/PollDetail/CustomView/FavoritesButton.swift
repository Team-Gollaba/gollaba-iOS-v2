//
//  FavoritesButton.swift
//  Gollaba
//
//  Created by 김견 on 12/31/24.
//

import SwiftUI

struct FavoritesButton: View {
    @Binding var isFavorite: Bool
    @State private var animateScale: CGFloat = 1.0
    @State private var animateRotation: Double = 0.0
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isFavorite.toggle()
                animateScale = 1.5 // 크기 커짐
                animateRotation += 360 // 한 바퀴 회전
            }
            // 딜레이를 주고 다시 원래 크기로 복귀
            withAnimation(.easeOut(duration: 0.2).delay(0.3)) {
                animateScale = 1.0
            }
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .scaleEffect(animateScale) // 크기 애니메이션
                .rotationEffect(.degrees(animateRotation)) // 회전 애니메이션
                .foregroundColor(isFavorite ? .red : .gray) // 색 전환
        }
        .tint(.red)
    }
}

#Preview {
    FavoritesButton(isFavorite: .constant(true))
}
