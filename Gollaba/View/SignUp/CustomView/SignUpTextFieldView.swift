//
//  SignUpTextFieldView.swift
//  Gollaba
//
//  Created by 김견 on 12/2/24.
//

import SwiftUI

struct SignUpTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isFocused: Bool
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .focused($focus)
                .font(.suitVariable20)
                .onChange(of: isFocused) { _, newValue in
                    focus = newValue
                }
                .onChange(of: focus) { _, newValue in
                    isFocused = newValue
                }
            
            Rectangle()
                .fill(.enrollButton)
                .frame(height: 1)
                
        }
    }
}

#Preview {
    SignUpTextFieldView(placeholder: "가입 이메일 *", text: .constant(""), isFocused: .constant(true))
}
