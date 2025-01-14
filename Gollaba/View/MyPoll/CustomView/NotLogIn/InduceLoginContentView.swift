//
//  InduceLoginContentView.swift
//  Gollaba
//
//  Created by 김견 on 12/29/24.
//

import SwiftUI

struct InduceLoginContentView: View {
    let icon: Image
    let iconColor: Color
    let iconBackgroundColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack (alignment: .top, spacing: 20) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(iconColor)
                .padding()
                .background(
                    Circle()
                        .fill(iconBackgroundColor)
                )
                
            VStack (alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.suitBold16)
                    .multilineTextAlignment(.leading)
                    
                
                Text(subtitle)
                    .font(.suitVariable16)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(minWidth: UIScreen.main.bounds.width - 80, maxWidth: UIScreen.main.bounds.width - 80, alignment: .leading)
        .padding(.vertical, 12)
    }
}

#Preview {
    InduceLoginContentView(icon: Image(systemName: "person"), iconColor: .accentColor, iconBackgroundColor: .red, title: "title", subtitle: "subtitle\nsubtitle")
}
