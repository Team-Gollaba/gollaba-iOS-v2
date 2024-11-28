//
//  TrendingPollResponse.swift
//  Gollaba
//
//  Created by 김견 on 11/28/24.
//

import Foundation

struct TrendingPollResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
    let data: [PollItem]
}
