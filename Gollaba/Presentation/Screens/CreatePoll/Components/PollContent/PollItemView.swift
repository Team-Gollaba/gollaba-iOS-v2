//
//  PollItemView.swift
//  Gollaba
//
//  Created by 김견 on 11/16/24.
//

import SwiftUI

struct CreatePollItemView: View {
    @Binding var pollItemName: String
    @Environment(CreatePollViewModel.self) var createPollViewModel
    @FocusState private var focus: Bool
    var isCreateModel: Bool
    var isShowDeleteButton: Bool
    @State var isShowImageDeleteButton: Bool = false
    
    var itemNumber: Int
    
    var onImageAttach: (() -> Void)
    var onAddPollItem: (() -> Void)
    var onDeletePollItem: (() -> Void)
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                
                let currentPostImage = createPollViewModel.postImage[itemNumber - 1]
                Button {
                    createPollViewModel.showPHPicker[itemNumber - 1] = true
                } label: {
                    if let image = currentPostImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 120)
                            .frame(minHeight: 120)
                            .clipped()
                            .onAppear {
                                isShowImageDeleteButton = true
                            }
                    } else {
                        VStack {
                            Text("이미지 첨부하기 +")
                                .font(.suitBold12)

                            Text("클릭 후 이미지를 첨부하세요.")
                                .font(.suitVariable12)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .foregroundStyle(.white)
                        .background(
                            Color.attach
                        )
                        .onAppear {
                            isShowImageDeleteButton = false
                        }
                    }
                }
                .sheet(isPresented: Binding(
                    get: { createPollViewModel.showPHPicker[itemNumber - 1] },
                    set: { createPollViewModel.showPHPicker[itemNumber - 1] = $0 }
                )) {
                    PHPickerRepresentable(selectedImage: Binding(
                        get: { createPollViewModel.uiImage[itemNumber - 1] },
                        set: { createPollViewModel.updatePostImage(index: itemNumber - 1, image: $0) }
                    ))
                    .ignoresSafeArea()
                }
                
                
                
                //                VStack {
                //                    Text("이미지 첨부하기 +")
                //                        .font(.suitBold12)
                //
                //                    Text("클릭 후 이미지를 첨부하세요.")
                //                        .font(.suitVariable12)
                //                        .multilineTextAlignment(.center)
                //                }
                //                .frame(maxWidth: .infinity)
                //                .frame(height: 80)
                //                .foregroundStyle(.white)
                //                .background(
                //                    Color.attach
                //                )
                //                .onTapGesture {
                //                    onImageAttach()
                //                }
                
                
                HStack {
                    ZStack {
                        if pollItemName.isEmpty {
                            Text("\(itemNumber) 항목 입력")
                                .font(.suitBold16)
                                .foregroundStyle(.gray)
                        }
                        
                        HStack {
                            Spacer()
                            
                            TextField("", text: $pollItemName)
                                .focused($focus)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .multilineTextAlignment(.center)
                                .font(.suitBold16)
                                .disabled(isCreateModel)
                                .onChange(of: focus, { oldValue, newValue in
                                    createPollViewModel.isPollItemFocused = newValue
                                })
                                .onChange(of: createPollViewModel.isPollItemFocused) { oldValue, newValue in
                                    if !newValue {
                                        focus = newValue
                                    }
                                }
                            
                            Spacer()
                        }
                    }
                }
                .frame(height: 28)
                .background(
                    Color.toolbarBackground
                )
            }
            .frame(width: UIScreen.main.bounds.width / 2 - 24)
            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 2)
            .blur(radius: isCreateModel ? 2 : 0)
            
            
            
            if isCreateModel {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.black.opacity(0.1))
                
                
                Button {
                    onAddPollItem()
                } label: {
                    VStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("새 후보 추가")
                            .font(.suitBold12)
                    }
                    .tint(.black)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(.selectedPoll)
                    )
                }
            }
            
            
            if isShowDeleteButton {
                VStack {
                    HStack {
                        Button {
                            onDeletePollItem()
                            createPollViewModel.postImage.remove(at: itemNumber - 1)
                            createPollViewModel.postImage.append(nil)
                        } label: {
                            Image(systemName: "minus.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .background(
                                    Circle()
                                        .fill(.white)
                                )
                        }
                        .tint(.red)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(-8)
            }
            
            if isShowImageDeleteButton {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            if createPollViewModel.postImage[itemNumber - 1] != nil {
                                createPollViewModel.updatePostImage(index: itemNumber - 1, image: nil)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(4)
                                .background(
                                    Circle()
                                        .fill(.white)
                                )
                        }
                        .tint(.black)
                        .padding(8)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
//
//#Preview {
//    PollItemView(pollItemName: .constant("pollItemName"), selectedItem: .constant(PhotosPickerItem(itemIdentifier: "")), isCreateModel: true, isShowDeleteButton: true, itemNumber: 1, onImageAttach: {}, onAddPollItem: {}, onDeletePollItem: {})
//}
