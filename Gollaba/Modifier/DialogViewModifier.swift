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
    var onPrimaryButton: () -> Void
    var onSecondaryButton: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPresented {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.suitBold24)
                                .foregroundStyle(.black)
                                .padding(.bottom, 30)
                            
                            self.content
                            
                            HStack {
                                Spacer()
                                
                                // Secondary Button
                                if let secondaryText = secondaryButtonText {
                                    Button {
                                        onSecondaryButton?()
                                        isPresented = false
                                    } label: {
                                        Text(secondaryText)
                                            .font(.suitVariable16)
                                            .foregroundStyle(.blue)
                                            .padding(.trailing, 12)
                                    }
                                }
                                
                                // Primary Button
                                Button {
                                    onPrimaryButton()
                                    isPresented = false
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
                    }
                }
            )
    }
}

public extension View {
    func dialog(isPresented: Binding<Bool>, title: String, content: Text? = nil, primaryButtonText: String, secondaryButtonText: String? = nil, onPrimaryButton: @escaping () -> Void, onSecondaryButton: (() -> Void)? = nil) -> some View {
        modifier(
            DialogViewModifier(isPresented: isPresented, title: title, content: content, primaryButtonText: primaryButtonText, secondaryButtonText: secondaryButtonText, onPrimaryButton: onPrimaryButton, onSecondaryButton: onSecondaryButton)
        )
    }
}
