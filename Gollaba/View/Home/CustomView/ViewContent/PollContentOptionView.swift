//
//  PollContentOptionView.swift
//  Gollaba
//
//  Created by 김견 on 11/19/24.
//

import SwiftUI

struct PollContentOptionView: View {
    var options: [PollOption]
    var isHorizontal: Bool = false
    let parentWidth: CGFloat
    @State var isOpen: Bool = false
    
    var body: some View {
        VStack {
            ThreeByTwoGridView(itemsCount: isOpen ? options.count : options.count > 2 ? 2 : options.count) { index in
                let option = options[index]
                PollContentOptionItemView(imageUrl: option.imageUrl, title: option.description, parentWidth: parentWidth)
            }
            
            if !isHorizontal && options.count > 2 {
                HStack {
                    Spacer()
                    
                    OpenAndCloseButton(isOpen: $isOpen)
                        .padding(.top, 12)
                }
            }
        }
    
        
//        GeometryReader { geometry in
//            HStack (spacing: 4) {
//                ZStack {
//                    Image("cocacola")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: (geometry.size.width - 4) / 2, height: 120)
//                        .clipped()
//                    
//                    Text(options[0])
//                        .font(.suitBold24)
//                        .foregroundStyle(.white)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(
//                            Rectangle()
//                                .fill(Color.black.opacity(0.5))
//                        )
//                }
//                
//                ZStack {
//                    Image("pepsi")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: (geometry.size.width - 4) / 2, height: 120)
//                        .clipped()
//                    
//                    Text(options[1])
//                        .font(.suitBold24)
//                        .foregroundStyle(.white)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(
//                            Rectangle()
//                                .fill(Color.black.opacity(0.5))
//                        )
//                }
//            }
//            .frame(maxHeight: 120)
//        }
//        .frame(height: 120) // 부모 뷰의 높이를 고정
    }
}

#Preview {
    PollContentOptionView(options: [], parentWidth: .infinity)
}

