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
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        PollContent(state: "종료", title: "제목", info: "정보") {
//                            goToPollDetail = true
//                        }
//                        ForEach(0..<10) { _ in
//                            PollContentWebStyle(title: "제목", endDate: Date(), state: "종료됨", options: ["코카콜라", "펩시"], action: {
//                                goToPollDetail = true
//                            })
//                            .frame(width: 320)
//                        }
                        
                        ForEach(pollList, id: \.self) { poll in
                            
                            PollContentWebStyle(title: poll.title, endDate: setDate(poll.endAt), state: getState(poll.endAt), options: poll.items, action: {
                                goToPollDetail = true
                            })
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
    HorizontalPollList(title: "Title", pollList: [], goToPollDetail: .constant(false))
}
