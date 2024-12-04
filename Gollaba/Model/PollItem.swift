//
//  PollItem.swift
//  Gollaba
//
//  Created by 김견 on 11/28/24.
//

import SwiftUI

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

struct PollOptionForParameter {
    let description: String
    let image: UIImage?
}
