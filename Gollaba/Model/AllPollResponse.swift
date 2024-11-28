//
//  PollItemData.swift
//  Gollaba
//
//  Created by 김견 on 11/28/24.
//

import Foundation

struct AllPollResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
    let data: AllPollData
}

struct AllPollData: Codable {
    var items: [PollItem]
    let page: Int
    let size: Int
    let totalCount: Int
    let totalPage: Int
    let empty: Bool
}
