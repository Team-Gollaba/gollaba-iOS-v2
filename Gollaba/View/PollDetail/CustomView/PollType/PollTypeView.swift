//
//  PollTypeView.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import SwiftUI

struct PollTypeView: View {
    var pollType: PollType
    var responseType: ResponseType
    
    var body: some View {
        HStack {
            PollTypeItemView(image: Image(pollType == PollType.anonymous ? "AnonymousIcon" : "SignIcon"), title: pollType == PollType.anonymous ? "익명 투표" : "기명 투표")
            
            Divider()
            
            PollTypeItemView(image: Image(responseType == ResponseType.single ? "OnlyPollIcon" : "PluralIcon"), title: responseType == ResponseType.single ? "단일 투표" : "복수 투표")
        }
    }
}

#Preview {
    PollTypeView(pollType: .anonymous, responseType: .single)
}
