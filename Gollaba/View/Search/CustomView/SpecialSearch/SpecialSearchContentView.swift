//
//  SpecialSearchContentView.swift
//  Gollaba
//
//  Created by 김견 on 1/1/25.
//

import SwiftUI

struct SpecialSearchContentView<SideContent: View, Content: View>: View {
    let title: String
    let image: Image
    let imageColor: Color
    let sideContent: SideContent
    let content: Content
    
    init(title: String, image: Image, imageColor: Color, @ViewBuilder sideContent: () -> SideContent, @ViewBuilder content: () -> Content) {
        self.title = title
        self.image = image
        self.imageColor = imageColor
        self.sideContent = sideContent()
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(imageColor)
                
                Text(title)
                    .font(.yangjin20)
                
                Spacer()
                
                sideContent
            }
            .padding()
            
            content
        }
//        .padding()
    }
}

//#Preview {
//    SpecialSearchContentView(title: "Title", image: Image(""), content: Text("Content"))
//}
