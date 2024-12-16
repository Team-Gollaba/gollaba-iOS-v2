//
//  ClearableTextFieldView.swift
//  Gollaba
//
//  Created by 김견 on 12/2/24.
//

import SwiftUI

struct ClearableTextFieldView: View {
    var placeholder: String
    @Binding var editText: String
    @Binding var isFocused: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $editText)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .focused($isTextFieldFocused)
                .font(.suitVariable16)
                .onChange(of: isFocused) { _, newValue in
                    isTextFieldFocused = newValue
                }
                .onChange(of: isTextFieldFocused) { _, newValue in
                    isFocused = newValue
                }
            
            Button {
                editText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
            }
            .opacity(editText.isEmpty ? 0 : 1)
        }
    }
}

#Preview {
    ClearableTextFieldView(placeholder: "placeholder", editText: .constant(""), isFocused: .constant(true))
}
