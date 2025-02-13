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
            .scaleEffect(configuration.isPressed ? 0.8 : (isSelected ? 1.2 : 1.0))
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: configuration.isPressed)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isSelected)
    }
}
