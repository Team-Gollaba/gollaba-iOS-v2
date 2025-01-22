//
//  SettingView.swift
//  Gollaba
//
//  Created by 김견 on 1/20/25.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthManager.self) private var authManager
    @State private var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 20) {
                    HStack (spacing: 20) {
                        ProfileImageView(imageUrl: authManager.userData?.profileImageUrl)
                            .frame(width: 80, height: 80)
                        
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
                                Task {
                                    await viewModel.convertImage(item: newValue)
//                                    await viewModel.uploadImage()
                                }
                            }
                            
                            if authManager.userData?.profileImageUrl != nil {
                                Button {
                                    
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
        .dialog(
            isPresented: $viewModel.showErrorDialog,
            title: "설정",
            content: Text("\(viewModel.errorMessage)")
        )
    }
}

#Preview {
    SettingView()
        .environment(AuthManager())
}
