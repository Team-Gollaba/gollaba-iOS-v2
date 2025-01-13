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
    
    @Binding var isScrollToLeading: Bool
    
    @State var position = ScrollPosition(edge: .leading)
    @State var isOpen: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                icon?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.yangjin20)
                
                Spacer()
                
                Button {
                    withAnimation(.spring) {
                        isOpen.toggle()
                    }
                } label: {
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .tint(.black)
                .contentShape(Rectangle())
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            
            if isOpen {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        ForEach(pollList, id: \.self) { poll in
                            
//                            PollContentView(poll: poll, isHorizontal: true, contentWidth: UIScreen.main.bounds.width - 60)
//                                .id(poll.id)
                            
                            HorizontalPollContentView(poll: poll, contentWidth: UIScreen.main.bounds.width - 120)
                                .id(poll.id)
                            
                        }
                    }
                }
                .scrollPosition($position)
                .onChange(of: isScrollToLeading) { _, newValue in
                    if newValue {
                        isScrollToLeading = false
                        withAnimation {
                            position.scrollTo(id: pollList.first?.id)
                        }
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
    HorizontalPollList(title: "Title", pollList: [], isScrollToLeading: .constant(false))
}
