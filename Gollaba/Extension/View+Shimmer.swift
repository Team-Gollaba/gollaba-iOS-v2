//
//  View+Shimmer.swift
//  Gollaba
//
//  Created by 김견 on 12/1/24.
//

import SwiftUI

extension View {
    func skeleton(isActive: Bool) -> some View {
        self.overlay(
            isActive ? Color.white : Color.clear
        )
        .overlay(
            isActive ? ShimmerView() : nil
        )
    }
}


