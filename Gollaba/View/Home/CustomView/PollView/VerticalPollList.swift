//
//  AllPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct VerticalPollList: View {
    
    var title: String?
    var pollList: [PollItem]
    
    @Binding var requestAddPoll: Bool
    @Binding var isEnd: Bool
    var icon: Image?
    
    var body: some View {
        LazyVStack (alignment: .leading) {
            if let title {
                HStack {
                    icon?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    
                    Text(title)
                        .font(.yangjin20)
                    
                }
                .padding(.leading, 16)
                .padding(.vertical, 5)
            }
            
            ForEach(pollList, id: \.self) { poll in
                
                PollContentWebStyle(poll: poll, contentWidth: UIScreen.main.bounds.width)
            }
            
            if !isEnd && !pollList.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onAppear {
                        
                        requestAddPoll = true
                        
                    }
            }
        }
    }
}

#Preview {
    VerticalPollList(title: "title", pollList: [], requestAddPoll: .constant(false), isEnd: .constant(false))
}
