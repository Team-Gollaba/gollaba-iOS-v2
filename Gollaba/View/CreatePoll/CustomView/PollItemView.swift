//
//  PollItemView.swift
//  Gollaba
//
//  Created by 김견 on 11/16/24.
//

import SwiftUI

struct PollItemView: View {
    @Binding var pollItemName: String
    @Environment(PollItemFocus.self) var pollItemFocus
    @FocusState private var focus: Bool
    var isCreateModel: Bool
    var isShowDeleteButton: Bool
    
    var itemNumber: Int
    
    var onImageAttach: (() -> Void)
    var onAddPollItem: (() -> Void)
    var onDeletePollItem: (() -> Void)
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                VStack {
                    Text("이미지 첨부하기 +")
                        .font(.suitBold12)
                    
                    Text("클릭 후 이미지를 첨부하세요.")
                        .font(.suitVariable12)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .foregroundStyle(.white)
                .background(
                    Color.attach
                )
                .onTapGesture {
                    onImageAttach()
                }
                
                
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
                                .font(.suitBold20)
                                .disabled(isCreateModel)
                                .onChange(of: focus, { oldValue, newValue in
                                    pollItemFocus.isPollItemFocused = newValue
                                })
                                .onChange(of: pollItemFocus.isPollItemFocused) { oldValue, newValue in
                                    print("focus: \(newValue)")
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
            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 2)
            .blur(radius: isCreateModel ? 2 : 0)
            

            
            if isCreateModel {
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
            
        }
    }
}

#Preview {
    PollItemView(pollItemName: .constant("pollItemName"), isCreateModel: true, isShowDeleteButton: true, itemNumber: 1, onImageAttach: {}, onAddPollItem: {}, onDeletePollItem: {})
}
