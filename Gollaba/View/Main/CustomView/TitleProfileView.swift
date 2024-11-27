//
//  TitleProfileView.swift
//  Gollaba
//
//  Created by 김견 on 11/27/24.
//

import SwiftUI
import Kingfisher

struct TitleProfileView: View {
    var imageUrl: URL
    var nickName: String
    
    var body: some View {
        HStack {
            KFImage(imageUrl)
                .resizable()
                .frame(width: 28, height: 28)
                .clipShape(Circle())
            
            Text(nickName)
                .font(.suitBold16)
                .foregroundStyle(.white)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.calendar)
                
        )
    }
}
//
//#Preview {
//    TitleProfileView()
//}
