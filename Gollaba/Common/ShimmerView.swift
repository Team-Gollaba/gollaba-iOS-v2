//
//  ShimmerEffect.swift
//  Gollaba
//
//  Created by 김견 on 12/1/24.
//

import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = -1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray)
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0.4),
                    Color.white.opacity(0.8),
                    Color.gray.opacity(0.4)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(20)
            .blur(radius: 30)
            .offset(x: phase * 400)
            .mask(
                RoundedRectangle(cornerRadius: 10)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1.0
                }
            }
        }
    }
}
