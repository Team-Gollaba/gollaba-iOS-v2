//
//  HomeDividerView.swift
//  Gollaba
//
//  Created by 김견 on 12/31/24.
//

import SwiftUI

struct HomeDividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 10)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.gray.opacity(0.2))
    }
}

#Preview {
    HomeDividerView()
}
