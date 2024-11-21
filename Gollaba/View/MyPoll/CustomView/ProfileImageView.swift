//
//  ProfileImageView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct ProfileImageView: View {
    var image: Image
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.toolbarBackgroundColor, lineWidth: 2)
                )
                .shadow(radius: 5)
        }
    }
}

#Preview {
    ProfileImageView(image: Image("cha_eun_woo"), action: {})
}
