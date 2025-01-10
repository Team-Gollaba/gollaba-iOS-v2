//
//  PollVotersView.swift
//  Gollaba
//
//  Created by 김견 on 1/10/25.
//

import SwiftUI

struct PollVotersView: View {
    @Binding var isPresented: Bool
    let title: String
    let voterNames: [String]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text("\'\(title)\' 투표자 목록")
                        .font(.yangjin20)
                }
                
                ForEach(voterNames, id: \.self) { name in
                    Text(name)
                        .font(.suitVariable16)
                        .padding()
                }
                
                if voterNames.isEmpty {
                    Text("투표자가 없습니다.")
                        .font(.suitVariable16)
                        .padding()
                        .foregroundStyle(.gray)
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .background(
                Rectangle()
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            )
            .padding(10)
        }
    }
}

#Preview {
    PollVotersView(isPresented: .constant(true), title: "title", voterNames: ["문장", "진문", "김견"])
}
