//
//  PollItemData.swift
//  Gollaba
//
//  Created by 김견 on 11/28/24.
//

import Foundation

struct PollResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
    let data: PollData
}

struct PollData: Codable {
    var items: [PollItem]
    let page: Int
    let size: Int
    let totalCount: Int
    let totalPage: Int
    let empty: Bool
}

struct PollItem: Codable, Hashable {
    let id: String
    let title: String
    let creatorName: String
    let responseType: String
    let pollType: String
    let endAt: String
    let readCount: Int
    let totalVotingCount: Int
    let items: [PollOption]
}

struct PollOption: Codable, Hashable {
    let id: Int
    let description: String
    let imageUrl: String?
    let votingCount: Int
}
