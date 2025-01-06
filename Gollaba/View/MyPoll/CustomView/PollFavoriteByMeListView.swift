//
//  PollFavoriteByMeListView.swift
//  Gollaba
//
//  Created by 김견 on 1/6/25.
//

import SwiftUI

struct PollFavoriteByMeListView: View {
    let pollFavoriteByMeList: [PollItem]
    var favoritePolls: [String]
    
    @Binding var requestAddPoll: Bool
    @Binding var isEnd: Bool
    
    var createFavorite: (String) -> Void
    var deleteFavorite: (String) -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack (alignment: .leading) {
                if !pollFavoriteByMeList.isEmpty {
                    ForEach(pollFavoriteByMeList, id: \.self) { poll in
                        PollFavoriteByMeView(
                            poll: poll,
                            isFavorite: favoritePolls.contains(poll.id),
                            onFavorite: { isFavorite in
                                if isFavorite {
                                    createFavorite(poll.id)
                                } else {
                                    deleteFavorite(poll.id)
                                }
                            })
                            
                    }
                } else {
                    Text("좋아요한 투표가 없습니다.")
                        .font(.suitBold24)
                }
            }
        }
    }
}

#Preview {
    PollFavoriteByMeListView(pollFavoriteByMeList: [], favoritePolls: [], requestAddPoll: .constant(false), isEnd: .constant(false), createFavorite: { _ in }, deleteFavorite: { _ in })
}
