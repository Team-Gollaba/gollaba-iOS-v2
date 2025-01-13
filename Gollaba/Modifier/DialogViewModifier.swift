//
//  DialogViewModifier.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

public struct DialogViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    var title: String
    var content: Text?
    var primaryButtonText: String
    var secondaryButtonText: String?
    var onPrimaryButton: (() -> Void)?
    var onSecondaryButton: (() -> Void)?
    
    @State private var scale: CGFloat = 0.0
    @State private var opacity: Double = 0.0
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPresented || opacity > 0.0 {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.suitBold24)
                                .foregroundStyle(.black)
                                .padding(.bottom, 30)
                            
                            if let content = self.content {
                                content
                                    .font(.suitVariable16)
                                    .foregroundStyle(.black)
                            }
                            
                            HStack {
                                Spacer()
                                
                                // Secondary Button
                                if let secondaryText = secondaryButtonText {
                                    Button {
                                        withAnimation {
                                            opacity = 0.0
                                            scale = 0.0
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isPresented = false
                                            onSecondaryButton?()
                                        }
                                    } label: {
                                        Text(secondaryText)
                                            .font(.suitVariable16)
                                            .foregroundStyle(.blue)
                                            .padding(.trailing, 12)
                                    }
                                }
                                
                                // Primary Button
                                Button {
                                    withAnimation {
                                        opacity = 0.0
                                        scale = 0.0
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        isPresented = false
                                        onPrimaryButton?()
                                    }
                                } label: {
                                    Text(primaryButtonText)
                                        .font(.suitVariable16)
                                        .foregroundStyle(.blue)
                                        .padding(.horizontal, 12)
                                }
                            }
                        }
                        .frame(maxWidth: 300)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.black, lineWidth: 1)
                                )
                                .shadow(radius: 5)
                        )
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                scale = 1.0
                                opacity = 1.0
                            }
                        }
                        .onChange(of: isPresented) { _, newValue in
                            if !newValue {
                                withAnimation {
                                    opacity = 0.0
                                    scale = 0.0
                                }
                            }
                        }
                    }
                }
            )
    }
}


public extension View {
    func dialog(isPresented: Binding<Bool>, title: String, content: Text? = nil, primaryButtonText: String = "확인", secondaryButtonText: String? = nil, onPrimaryButton: (() -> Void)? = nil, onSecondaryButton: (() -> Void)? = nil) -> some View {
        modifier(
            DialogViewModifier(isPresented: isPresented, title: title, content: content, primaryButtonText: primaryButtonText, secondaryButtonText: secondaryButtonText, onPrimaryButton: onPrimaryButton, onSecondaryButton: onSecondaryButton)
        )
    }
}
