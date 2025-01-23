//
//  NotificationContentView.swift
//  Gollaba
//
//  Created by 김견 on 1/21/25.
//

import SwiftUI

struct NotificationContentView: View {
    var body: some View {
        HStack (alignment: .top, spacing: 12) {
            ProfileImageView(width: 60, height: 60)
            
            VStack (alignment: .leading, spacing: 8) {
                HStack {
                    Text("진문장은 잘생겼을까?")
                        .font(.suitBold16)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Text("1월 6일")
                        .font(.suitVariable16)
                        .foregroundStyle(.gray)
                }
                
                Text("투표가 마감되었습니다.")
                    .font(.suitVariable16)
            }
        }
        .padding()
    }
}

#Preview {
    NotificationContentView()
}
