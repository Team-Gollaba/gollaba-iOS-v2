//
//  CustomTabViewButton.swift
//  Gollaba
//
//  Created by 김견 on 11/8/24.
//

import SwiftUI

struct CustomTabViewButton: View {
    var action: () -> Void
    var image: Image
    var title: String
    var isSelected: Bool
    
    var body: some View {
        Button {
            action()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        
        } label: {
            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .scaleEffect(isSelected ? 1.2 : 1)
                
//                Text(title)
//                    .font(isSelected ? .suitBold12 : .suitVariable12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .buttonStyle(ScaleOnPressStyle(isSelected: isSelected))
        .foregroundStyle(isSelected ? .signUpButtonEnd : .gray)
    }
}

#Preview {
    CustomTabViewButton(action: {}, image: Image(systemName: "person"), title: "title", isSelected: true)
}
