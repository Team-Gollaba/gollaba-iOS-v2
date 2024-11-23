//
//  goToMyPollListButton.swift
//  Gollaba
//
//  Created by 김견 on 11/24/24.
//

import SwiftUI

struct GoToMyPollListButton: View {
    var icon: Image
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.yangjin20)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .padding()
            }
            .padding(.leading, 16)
            .padding(.vertical, 5)
        }
        .tint(.black)
    }
}

#Preview {
    GoToMyPollListButton(icon: Image(systemName: "person"), title: "title", action: {})
}
