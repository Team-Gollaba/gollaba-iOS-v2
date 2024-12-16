//
//  SearchPollView.swift
//  Gollaba
//
//  Created by 김견 on 11/14/24.
//

import SwiftUI

struct SearchPollView: View {
    @Binding var text: String
    @Binding var searchFocus: Bool
    @FocusState var focus: Bool
    var action: () -> Void
    
    var body: some View {
        HStack (spacing: 10) {
            
            TextField("제목으로 투표를 검색하세요.", text: $text)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .font(.suitVariable16)
                .focused($focus)
                .onChange(of: searchFocus) { oldValue, newValue in
                    focus = newValue
                }
                .onChange(of: focus) { oldValue, newValue in
                    searchFocus = newValue
                }
            
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
            }
            .opacity(text.isEmpty ? 0 : 1)
            
            Button {
                action()
            } label: {
                Image("Search")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.searchBorder, lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    SearchPollView(text: .constant(""), searchFocus: .constant(true), action: {})
}
