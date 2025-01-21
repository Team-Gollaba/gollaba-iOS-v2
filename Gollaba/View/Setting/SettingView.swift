//
//  SettingView.swift
//  Gollaba
//
//  Created by 김견 on 1/20/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            
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
    }
}

#Preview {
    SettingView()
}
