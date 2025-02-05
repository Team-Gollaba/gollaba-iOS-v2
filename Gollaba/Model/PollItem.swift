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
    var creatorProfileUrl: String?
    let responseType: String
    let pollType: String
    let endAt: String
    let readCount: Int
    let totalVotingCount: Int
    let items: [PollOption]
    
    init(
        id: String,
        title: String,
        creatorName: String,
        creatorProfileUrl: String?,
        responseType: String,
        pollType: String,
        endAt: String,
        readCount: Int,
        totalVotingCount: Int,
        items: [PollOption]
    ) {
        self.id = id
        self.title = title
        self.creatorName = creatorName
        self.creatorProfileUrl = creatorProfileUrl?.replacingOccurrences(of: "http://", with: "https://")
        self.responseType = responseType
        self.pollType = pollType
        self.endAt = endAt
        self.readCount = readCount
        self.totalVotingCount = totalVotingCount
        self.items = items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.creatorName = try container.decode(String.self, forKey: .creatorName)
        let rawProfileUrl = try container.decodeIfPresent(String.self, forKey: .creatorProfileUrl)
        self.creatorProfileUrl = rawProfileUrl?.replacingOccurrences(of: "http://", with: "https://")
        self.responseType = try container.decode(String.self, forKey: .responseType)
        self.pollType = try container.decode(String.self, forKey: .pollType)
        self.endAt = try container.decode(String.self, forKey: .endAt)
        self.readCount = try container.decode(Int.self, forKey: .readCount)
        self.totalVotingCount = try container.decode(Int.self, forKey: .totalVotingCount)
        self.items = try container.decode([PollOption].self, forKey: .items)
    }
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

struct PollOptionForUpdate {
    let description: String
    let imageUrl: String
}

extension PollItem {
    static func tempDataList() -> [PollItem] {
        Array(
            repeating: PollItem(
                id: "-1",
                title: "title title title",
                creatorName: "creatorName",
                creatorProfileUrl: "",
                responseType: "responseType",
                pollType: "pollType",
                endAt: "2024. 22. 22.",
                readCount: 0,
                totalVotingCount: 0,
                items: Array(
                    repeating: PollOption(
                        id: 0,
                        description: "",
                        imageUrl: "",
                        votingCount: 1
                    ),
                    count: 2
                )
            ),
            count: 10
        )
    }
    
    static func mockData() -> PollItem {
        PollItem(
            id: "-1",
            title: "title title title",
            creatorName: "creatorName",
            creatorProfileUrl: "",
            responseType: "responseType",
            pollType: "pollType",
            endAt: "2024. 22. 22.",
            readCount: 0,
            totalVotingCount: 0,
            items: Array(
                repeating: PollOption(
                    id: 0,
                    description: "",
                    imageUrl: "",
                    votingCount: 1
                ),
                count: 2
            )
        )
    }
}
