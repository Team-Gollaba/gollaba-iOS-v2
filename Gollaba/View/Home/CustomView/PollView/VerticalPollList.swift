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
        ScrollViewReader { proxy in
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
                    
                    PollContentView(poll: poll, contentWidth: UIScreen.main.bounds.width)
                }
                
                Color.clear
                    .frame(height: 0)
                    .id("Bottom")
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onChange(of: geometry.frame(in: .global).minY) { _, newValue in
                                    print("newValue: \(newValue), UIScreen.main.bounds.height: \(UIScreen.main.bounds.height)")
                                    if newValue < UIScreen.main.bounds.height + 100 && !isEnd {
                                        requestAddPoll = true
                                    }
                                }
                        }
                    )
                
                //            if !isEnd && !pollList.isEmpty {
                //                ProgressView()
                //                    .frame(maxWidth: .infinity, alignment: .center)
                //                    .padding()
                //                    .onAppear {
                //
                //                        requestAddPoll = true
                //
                //                    }
                //            }
            }
        }
    }
}

#Preview {
    VerticalPollList(title: "title", pollList: [], requestAddPoll: .constant(false), isEnd: .constant(false))
}
