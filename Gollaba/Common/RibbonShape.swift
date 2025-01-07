//
//  RibbonShape.swift
//  Gollaba
//
//  Created by 김견 on 1/7/25.
//

import SwiftUI

struct RibbonShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: width * 2 / 3, y: 0))
            path.addLine(to: CGPoint(x: width, y: height * 1 / 3))
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
        }
    }
}
#Preview {
    RibbonShape()
}
