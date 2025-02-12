//
//  RequestAddButton.swift
//  Gollaba
//
//  Created by 김견 on 2/12/25.
//

import SwiftUI

struct RequestAddButton: View {
    @Binding var requestAddPoll: Bool
    let onClick: () -> Void
    
    var body: some View {
        
        if requestAddPoll {
            GollabaLoadingView()
        } else {
            Button {
                onClick()
            } label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
                    .padding()
                    .background(
                        Circle()
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                    )
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    RequestAddButton(requestAddPoll: .constant(true), onClick: {})
}
