//
//  SettingView.swift
//  Gollaba
//
//  Created by 김견 on 1/20/25.
//

import SwiftUI
import PhotosUI
import AlertToast

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 20) {
                    HStack (spacing: 20) {
                        ProfileImageView(imageUrl: authManager.userData?.profileImageUrl, width: 80, height: 80)
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text(authManager.userData?.name ?? "사용자")
                                .font(.suitBold20)
                            
                            Text(authManager.userData?.email ?? "example@example.com")
                                .font(.suitVariable12)
                                .foregroundStyle(.black.opacity(0.4))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.showSetProfileImageDialog = true
                            }
                        } label: {
                            Text("프로필 이미지 바꾸기")
                                .font(.suitVariable16)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                                )
                        }
                        
                        Button {
                            withAnimation {
                                viewModel.showSetNicknameDialog = true
                            }
                        } label: {
                            Text("닉네임 바꾸기")
                                .font(.suitVariable16)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                                )
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    OptionBoxView(title: "앱 내 알림") {
                        HStack {
                            Toggle(isOn: $viewModel.isNotificationOn) {
                                Text("알림")
                                    .font(.suitBold16)
                                    .foregroundStyle(AppStorageManager.shared.permissionForNotification ?? false ? .black : .gray.opacity(0.3))
                            }
                            .toggleStyle(SwitchToggleStyle(tint: AppStorageManager.shared.permissionForNotification ?? false ? .signUpButtonEnd : .gray.opacity(0.3)))
                            .disabled(!(AppStorageManager.shared.permissionForNotification ?? false))
                            .onChange(of: viewModel.isNotificationOn) {
                                
                                Task {
                                    await viewModel.updateNotification()
                                }
                            }
                        }
                    }
                    
                    Button {
                        viewModel.showDeleteAccountDialog = true
                    } label: {
                        Text("회원탈퇴")
                            .font(.suitBold16)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red)
                            )
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            
            if viewModel.showSetProfileImageDialog {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            viewModel.showSetProfileImageDialog = false
                        }
                    }
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("프로필 이미지 바꾸기")
                                    .font(.suitBold20)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        viewModel.showSetProfileImageDialog = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .tint(.black)
                            }
                            PhotosPicker(selection: $viewModel.selectedItem) {
                                Text("앨범에서 사진 선택")
                                    .font(.suitVariable16)
                                    .foregroundStyle(.black)
                            }
                            .onChange(of: viewModel.selectedItem) { _, newValue in
                                if newValue != nil {
                                    Task {
                                        await viewModel.convertImage(item: newValue)
                                        await viewModel.updateProfileImage()
                                        await viewModel.getUser()
                                    }
                                }
                            }
                            
                            if authManager.userData?.profileImageUrl != nil {
                                Button {
                                    Task {
                                        viewModel.selectedItem = nil
                                        await viewModel.deleteProfileImage()
                                        await viewModel.getUser()
                                    }
                                } label: {
                                    Text("기본 이미지로 변경")
                                        .font(.suitVariable16)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .edgesIgnoringSafeArea(.all)
                        )
                        .offset(y: viewModel.showSetProfileImageDialog ? 0 : geometry.size.height)
                    }
                }
                .transition(.move(edge: .bottom))
                
            }
            
            if viewModel.showSetNicknameDialog {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            viewModel.showSetNicknameDialog = false
                        }
                    }
                
                GeometryReader { geometry in
                    VStack {
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 20) {
                            HStack {
                                Text("닉네임 바꾸기")
                                    .font(.suitBold20)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        viewModel.showSetNicknameDialog = false
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .tint(.black)
                            }
                            
                            ClearableTextFieldView(
                                placeholder: "바꾸려는 닉네임",
                                editText: $viewModel.nickName,
                                isFocused: $viewModel.nickNameFocused
                            )
                            
                            Button {
                                if viewModel.isValidNickname() {
                                    Task {
                                        await viewModel.updateUserName()
                                        viewModel.showSetNicknameDialog = false
                                    }
                                }
                            } label: {
                                Text("변경")
                                    .font(.suitVariable16)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.enrollButton)
                                    )
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .edgesIgnoringSafeArea(.all)
                        )
                        .padding()
                        .onAppear {
                            viewModel.nickNameFocused = true
                        }
                        .onDisappear {
                            viewModel.nickNameFocused = false
                        }
                        
                        Spacer()
                    }
                }
            }
        }
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
            
            ToolbarItem(placement: .principal) {
                Text("설정")
                    .font(.suitBold24)
            }
        }
        .onAppear {
            viewModel.nickName = authManager.userData?.name ?? ""
            viewModel.setAuthManager(authManager)
        }
        .onDisappear {
            viewModel.showSetProfileImageDialog = false
            viewModel.showSetNicknameDialog = false
        }
        .onChange(of: authManager.jwtToken, { _, newValue in
            if newValue == nil {
                dismiss()
            }
        })
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "설정",
            content: Text("\(viewModel.errorMessage)")
        )
        .dialog(
            isPresented: $viewModel.showDeleteAccountDialog,
            title: "회원탈퇴",
            content: Text("정말로 탈퇴 하시겠습니까?"),
            primaryButtonText: "확인",
            secondaryButtonText: "취소",
            onPrimaryButton: {
                Task {
                    await viewModel.deleteAccount()
                }
            }
        )
        .toast(isPresenting: $viewModel.showSuccessUpdateUserNameToast, alert: {
            AlertToast(type: .regular, title: "닉네임 변경이 완료되었습니다.", style: .style(titleFont: .suitBold16))
        })
        .toast(isPresenting: $viewModel.showInValidToast, alert: {
            switch viewModel.nicknameError {
            case .Empty:
                return AlertToast(type: .error(.red), title: "닉네임을 입력해주세요.", style: .style(titleFont: .suitBold16))
            case .Length:
                return AlertToast(type: .error(.red), title: "닉네임은 2자 이상 10자 이하로 입력해주세요.", style: .style(titleFont: .suitBold16))
            case .ContainsBlank:
                return AlertToast(type: .error(.red), title: "닉네임에 공백이 포함되어 있습니다.", style: .style(titleFont: .suitBold16))
            case .Duplicate:
                return AlertToast(type: .error(.red), title: "이미 사용중인 닉네임입니다.", style: .style(titleFont: .suitBold16))
            case .SpecialCharacter:
                return AlertToast(type: .error(.red), title: "닉네임에 특수문자가 포함되어 있습니다.", style: .style(titleFont: .suitBold16))
            case .ContainsForbiddenCharacter:
                return AlertToast(type: .error(.red), title: "닉네임에 금지된 단어가 포함되어 있습니다.", style: .style(titleFont: .suitBold16))
            default:
                return AlertToast(type: .error(.red), title: "")
            }
        })
    }
}

#Preview {
    SettingView()
        .environment(AuthManager())
}
