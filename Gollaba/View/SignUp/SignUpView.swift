//
//  SignUpView.swift
//  Gollaba
//
//  Created by 김견 on 12/2/24.
//

import SwiftUI
import PhotosUI
import AlertToast

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) var authManager
    @StateObject var viewModel = SignUpViewModel()
    
    @State private var accessToken: String = ""
    @State private var email: String = ""
    @State private var providerType: ProviderType = .none
    
    init(accessToken: String, email: String, providerType: ProviderType) {
        _accessToken = State(initialValue: accessToken)
        _email = State(initialValue: email)
        _providerType = State(initialValue: providerType)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Color.clear
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.emailFocused = false
                        viewModel.nickNameFocused = false
                    }
            }
            
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
                    if viewModel.isValid() {
                        Task {
                            authManager.jwtToken = await viewModel.signUp()
                            dismiss()
                        }
                    }
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
            .dialog(
                isPresented: $viewModel.showAlert,
                title: "투표 만들기",
                content: Text(viewModel.alertMessage),
                primaryButtonText: "확인",
                onPrimaryButton: {
                    
                }
            )
            .toast(isPresenting: $viewModel.showInValidToast, alert: {
                switch viewModel.nicknameError {
                case .Empty:
                    return AlertToast(type: .error(.red), title: "닉네임을 입력해주세요.", style: .style(titleFont: .suitBold16))
                case .Length:
                    return AlertToast(type: .error(.red), title: "닉네임은 2자 이상 10자 이하로 입력해주세요.", style: .style(titleFont: .suitBold16))
                case .ContainsBlank:
                    return AlertToast(type: .error(.red), title: "닉네임에 공백이 포함되어 있습니다.", style: .style(titleFont: .suitBold16))
                case .SpecialCharacter:
                    return AlertToast(type: .error(.red), title: "닉네임에 특수문자가 포함되어 있습니다.", style: .style(titleFont: .suitBold16))
                case .ContainsForbiddenCharacter:
                    return AlertToast(type: .error(.red), title: "닉네임에 금지된 단어가 포함되어 있습니다.", style: .style(titleFont: .suitBold16))
                default:
                    return AlertToast(type: .error(.red), title: "")
                }
            })
            .onAppear {
                viewModel.providerAccessToken = accessToken
                viewModel.email = email
                viewModel.providerType = providerType
            }
        }
    }
}

#Preview {
    SignUpView(accessToken: "", email: "email@example.com", providerType: .kakao)
}
