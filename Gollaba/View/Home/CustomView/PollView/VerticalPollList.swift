//
//  AllPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct VerticalPollList: View {
    @Binding var requestAddPoll: Bool
    @Binding var isEnd: Bool
    
    var pollList: [PollItem]
    var icon: Image?
    var title: String
    
    var body: some View {
        LazyVStack (alignment: .leading) {
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
            
            
            ForEach(pollList, id: \.self) { poll in
                
                PollContentWebStyle(poll: poll)
            }
            
            if !isEnd {
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
    VerticalPollList(requestAddPoll: .constant(false), isEnd: .constant(false), pollList: [], title: "title")
}
