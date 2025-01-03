//
//  ProfileImageView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    var image: KFImage?
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.toolbarBackgroundColor, lineWidth: 2)
                    )
                    .shadow(radius: 5)
            }
        }
        .padding(.bottom)
    }
}

//#Preview {
//    ProfileImageView(image: KFImage("cha_eun_woo"), action: {})
//}
