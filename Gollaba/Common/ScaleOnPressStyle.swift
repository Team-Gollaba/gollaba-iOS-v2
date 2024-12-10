//
//  ScaleOnPressStyle.swift
//  Gollaba
//
//  Created by 김견 on 12/10/24.
//

import SwiftUI

struct ScaleOnPressStyle: ButtonStyle {
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : (isSelected ? 1.1 : 1.0))
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isSelected)
    }
}
