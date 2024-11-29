//
//  PopularPollList.swift
//  Gollaba
//
//  Created by 김견 on 11/9/24.
//

import SwiftUI

struct HorizontalPollList: View {
    var icon: Image?
    var title: String
    var pollList: [PollItem]
    
    @Binding var goToPollDetail: Bool
    @Binding var isEnd: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            if !isEnd {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        ForEach(pollList, id: \.self) { poll in
                            
                            PollContentWebStyle(poll: poll, isHorizontal: true)
                                .frame(width: UIScreen.main.bounds.width - 60)
//                            
//                            PollContentWebStyle(title: poll.title, endDate: setDate(poll.endAt), state: getState(poll.endAt), options: poll.items, action: {
//                                goToPollDetail = true
//                            })
//                            .frame(width: UIScreen.main.bounds.width - 60)
                        }
                    }
                }
                
            
        }
        .padding(.bottom, 16)
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
    HorizontalPollList(title: "Title", pollList: [], goToPollDetail: .constant(false), isEnd: .constant(true))
}
