//
//  AllPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

struct VerticalPollList: View {
    @Binding var goToPollDetail: Bool
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
                
                PollContentWebStyle(title: poll.title, endDate: setDate(poll.endAt), state: getState(poll.endAt), options: poll.items, action: {
                    goToPollDetail = true
                })
            }
            
            if !isEnd {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onAppear {
                        
                        requestAddPoll = true
                        print("progressview onappear")
                        
                    }
            }
        }
    }
    
    func setDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    func getState(_ dateString: String) -> Bool {
        let date = setDate(dateString)
        return date > Date()
    }
}

#Preview {
    VerticalPollList(goToPollDetail: .constant(false), requestAddPoll: .constant(false), isEnd: .constant(false), pollList: [], icon: Image(systemName: "square.and.arrow.up"), title: "📝 전체 투표")
}
