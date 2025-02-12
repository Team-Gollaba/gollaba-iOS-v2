//
//  GollabaLoadingView.swift
//  Gollaba
//
//  Created by 김견 on 2/12/25.
//

import SwiftUI

struct GollabaLoadingView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [.enrollButton, .attach, .signUpButtonEnd, .enrollButton]),
                        center: .center
                    ),
                    lineWidth: 8
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-rotation))
                
            
            Image("AppIconImage")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
        }
    }
}

#Preview {
    GollabaLoadingView()
}
