//
//  ProfileImageDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/21/24.
//

import SwiftUI

struct ProfileImageDetailView: View {
    @Environment(\.dismiss) var dismiss
    var image: Image
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 600)
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .tint(.white)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .background(.black)
    }
}

#Preview {
    ProfileImageDetailView(image: Image("profile"))
}
