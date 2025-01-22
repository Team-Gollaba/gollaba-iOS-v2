//
//  NotificationView.swift
//  Gollaba
//
//  Created by 김견 on 1/20/25.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<10) { _ in
                    NotificationContentView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
                Text("알림 목록")
                    .font(.suitBold24)
            }
        }
    }
}

#Preview {
    NotificationView()
}
