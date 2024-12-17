//
//  DragToHideModifier.swift
//  Gollaba
//
//  Created by 김견 on 12/17/24.
//

import SwiftUI

struct DragToHideModifier: ViewModifier {
    @Binding var isHide: Bool
    
    @State private var dragStartLocation: CGFloat = 0.0
    @State private var dragEndLocation: CGFloat = 0.0
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        // 드래그 시작 시 위치 기록
                        if dragStartLocation == 0.0 {
                            dragStartLocation = value.location.y
                        }
                        dragEndLocation = value.location.y
                    }
                    .onEnded { _ in
                        // 손가락을 뗄 때 마지막 방향만 결정
                        if dragEndLocation > dragStartLocation {
                            isHide = false
                        } else if dragEndLocation < dragStartLocation {
                            isHide = true
                        }
                        // 드래그 위치 초기화
                        dragStartLocation = 0.0
                        dragEndLocation = 0.0
                    }
            )
    }
}

extension View {
    func dragToHide(isHide: Binding<Bool>) -> some View {
        self.modifier(DragToHideModifier(isHide: isHide))
    }
}
