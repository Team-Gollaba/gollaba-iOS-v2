//
//  View+Shimmer.swift
//  Gollaba
//
//  Created by 김견 on 12/1/24.
//

import SwiftUI

extension View {
    func shimmer() -> some View {
        self.overlay(
            ShimmerView()
                .mask(self)
        )
    }
}


