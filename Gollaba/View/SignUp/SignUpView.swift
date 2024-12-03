//
//  SignUpView.swift
//  Gollaba
//
//  Created by 김견 on 12/2/24.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack (spacing: 32) {
            Text("회원가입")
                .font(.yangjin36)
            
            PhotosPicker(selection: $viewModel.selectedItem) {
                if let image = viewModel.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .clipped()
                } else {
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding()
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 160, height: 160)
            .background(.gray.opacity(0.7))
            .clipShape(Circle())
            .onChange(of: viewModel.selectedItem) { _, newValue in
                Task {
                    await viewModel.convertImage(item: newValue)
                }
            }
            
            
            Text("클릭해서 원하는 이미지로 교체할 수 있어요.")
                .font(.suitVariable16)
                .padding(.bottom, 60)
            
            SignUpTextFieldView(
                placeholder: "가입 이메일 *",
                text: $viewModel.email,
                isFocused: $viewModel.emailFocused
            )
            
            SignUpTextFieldView(
                placeholder: "닉네임 *",
                text: $viewModel.nickName,
                isFocused: $viewModel.nickNameFocused
            )
            
            SignUpButtonView {
                
            }
        }
        .padding(32)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
