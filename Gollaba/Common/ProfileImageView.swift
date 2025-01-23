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
    var width: CGFloat
    var height: CGFloat
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            Group {
                if let imageUrl {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: width, height: height)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(.gray, lineWidth: 2)
            )
        }
        .padding(.vertical)
        .frame(width: width, height: height)
    }
}

#Preview {
    ProfileImageView(width: 40, height: 40)
}
