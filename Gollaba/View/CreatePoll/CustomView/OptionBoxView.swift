//
//  ContentBoxView.swift
//  Gollaba
//
//  Created by 김견 on 11/14/24.
//

import SwiftUI

struct OptionBoxView<Content: View>: View {
    let content: Content
    var title: String
    
    init(title: String, content: () -> Content) {
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.suit_variable12)
                .foregroundStyle(.pollContentTitleFont)
            
            content
//                .frame(height: 24)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.black, lineWidth: 1)
                )
                
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    OptionBoxView(title: "title") {
        Text("content")
    }
}
