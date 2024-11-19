//
//  PollDetailView.swift
//  Gollaba
//
//  Created by 김견 on 11/18/24.
//

import SwiftUI

struct PollDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var pollItemName: [String] = ["코카콜라", "펩시", "펩시 제로", "환타", "맥주", "소주"]
    @State var selectedPoll: Int? = nil
    @State var pollButtonState: PollButtonState = .normal
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 28) {
                
                VStack {
                    HStack (spacing: 12) {
                        Image(systemName: "arrowtriangle.forward.fill")
                            .resizable()
                            .foregroundStyle(.enrollButton)
                            .frame(width: 16, height: 28)
                            .padding(.leading, -10)
                        
                        Text("코카콜라 vs 펩시")
                            .font(.suitBold32)
                            
                    }
                    
                    
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                        
                        Text("홍길동 · 2022. 7. 30. 마감")
                            .font(.suitVariable16)
                        
                        Image(systemName: "eye")
                            .padding(.leading, 12)
                        
                        Text("4")
                            .font(.suitVariable16)
                    }
                    
                }
                
                HStack {
                    Image("AnonymousIcon")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .scaledToFill()
                    
                    Text("익명 투표")
                        .font(.suitBold20)
                }
                
                ThreeByTwoGridPollDetail(pollItemName: $pollItemName, selectedPoll: $selectedPoll)
                
                HStack {
                    Spacer()
                    
                    PollButton(pollbuttonState: $pollButtonState)
                    
                    Spacer()
                }
                
                PollResultView()
                
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
        }
    }
}

#Preview {
    PollDetailView()
}
