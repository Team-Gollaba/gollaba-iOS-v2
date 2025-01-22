//
//  ProfileImageView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    var imageUrl: String?
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            if let imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.gray, lineWidth: 1)
                    )
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundStyle(.gray)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical)
    }
}

//#Preview {
//    ProfileImageView(image: KFImage("cha_eun_woo"), action: {})
//}
