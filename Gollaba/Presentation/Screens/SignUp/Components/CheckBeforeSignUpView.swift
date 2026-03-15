//
//  CheckBeforeSignUpView.swift
//  Gollaba
//
//  Created by 김견 on 2/15/25.
//

import SwiftUI

struct CheckBeforeSignUpView: View {
    @Binding var isPresented: Bool
    let email: String
    let nickname: String
    let onSignUp: () -> Void
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack (alignment: .leading, spacing: 20) {
                Text("회원가입")
                    .font(.suitBold24)
                    .padding(.bottom, 8)
                
                Text("다음 정보로 회원가입을 진행하시겠습니까?")
                    .font(.suitVariable16)
                
                VStack (alignment: .leading, spacing: 8) {
                    Text("이메일: ")
                        .font(.suitBold16) +
                    Text(email)
                        .font(.suitVariable16)
                    
                    Text("닉네임: ")
                        .font(.suitBold16) +
                    Text(nickname)
                        .font(.suitVariable16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
                
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Text("취소")
                            .font(.suitVariable16)
                            .foregroundStyle(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            )
                    }
                    
                    Button {
                        onSignUp()
                    } label: {
                        Text("가입하기")
                            .font(.suitVariable16)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.enrollButton, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
            )
            .padding(20)
        }
    }
}

#Preview {
    CheckBeforeSignUpView(isPresented: .constant(true), email: "email@example.com", nickname: "nickname", onSignUp: {})
}
