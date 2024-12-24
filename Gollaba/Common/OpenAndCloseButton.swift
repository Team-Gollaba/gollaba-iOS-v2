//
//  OpenAndCloseButton.swift
//  Gollaba
//
//  Created by 김견 on 12/18/24.
//

import SwiftUI

struct OpenAndCloseButton: View {
    @Binding var isOpen: Bool
    
    var body: some View {
        Button {
//            withAnimation {
                isOpen.toggle()
//            }
        } label: {
            Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
        .tint(.black)
        .frame(alignment: .trailing)
//        .padding(.top, 12)
    }
}

#Preview {
    OpenAndCloseButton(isOpen: .constant(false))
}
