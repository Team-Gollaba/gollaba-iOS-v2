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
        } label: {
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .padding(.bottom, 4)
                Text(title)
                    .font(.suit_variable12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .shadow(radius: 0)
            .scaleEffect(isSelected ? 1.2 : 1.0)
        }
    }
}

#Preview {
    CustomTabViewButton(action: {}, image: Image(systemName: "person"), title: "title", isSelected: true)
}
