//
//  PollTypeItemView.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import SwiftUI

struct PollTypeItemView: View {
    var image: Image
    var title: String
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 28, height: 28)
                .scaledToFill()
            
            Text(title)
                .font(.suitBold20)
        }
    }
}

#Preview {
    PollTypeItemView(image: Image(systemName: "person"), title: "title")
}
