//
//  SearchKeyword.swift
//  Gollaba
//
//  Created by 김견 on 12/20/24.
//

import Foundation
import SwiftData

@Model
class SearchKeyword {
    @Attribute(.unique) var keyword: String
    var timeStamp: Date = Date()

    init(keyword: String) {
        self.keyword = keyword
    }
    
    init(keyword: String, timeStamp: Date) {
        self.keyword = keyword
        self.timeStamp = timeStamp
    }
}
