//
//  ProfileNameView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct ProfileNameView: View {
    @State var isEditing: Bool = false
    @State var newName: String = ""
    @Binding var name: String
    var email: String
    
    var body: some View {
        VStack (alignment: .center) {
            HStack {
                if isEditing {
                    
                    TextField("새 닉네임 *", text: $newName)
                        .font(.suitBold20)
                        .frame(height: 40)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray),
                            alignment: .bottom
                        )
                    
                    Button {
                        name = newName
                        withAnimation {
                            isEditing = false
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    
                    Button {
                        withAnimation {
                            isEditing = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    
                } else {
                    Text(name)
                        .font(.suitBold20)
                    
                    Button {
                        withAnimation {
                            isEditing = true
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    .tint(.black)
                }
            }
            .tint(.black)
            .frame(height: 28)
            .padding(.bottom, 8)
            
            Text(email)
                .font(.suitVariable16)
                .foregroundStyle(.attach)
        }
        .frame(maxWidth: 250)
    }
}

#Preview {
    ProfileNameView(name: .constant("name"), email: "email")
}
