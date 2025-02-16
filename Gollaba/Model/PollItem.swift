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
    let votedPeopleCount: Int
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
        votedPeopleCount: Int,
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
        self.votedPeopleCount = votedPeopleCount
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
        self.votedPeopleCount = try container.decode(Int.self, forKey: .votedPeopleCount)
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
                votedPeopleCount: 0,
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
            votedPeopleCount: 0,
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
    
    static func forScreenShotData1() -> PollItem {
        PollItem(
            id: "1",
            title: "오늘 저녁 메뉴!!",
            creatorName: "카레가좋아",
            creatorProfileUrl: "https://gollaba-bucket-dev.s3.ap-northeast-2.amazonaws.com/profile-images/26-f0fe2c78-6ce1-42ee-aeb3-eb52acbc1620.jpeg",
            responseType: "SINGLE",
            pollType: "ANONYMOUS",
            endAt: "2025-02-16T23:56:00",
            readCount: 45,
            votedPeopleCount: 7,
            totalVotingCount: 7,
            items: [
                PollOption(
                    id: 1,
                    description: "카레",
                    imageUrl: "https://gollaba-bucket-dev.s3.ap-northeast-2.amazonaws.com/profile-images/26-f0fe2c78-6ce1-42ee-aeb3-eb52acbc1620.jpeg",
                    votingCount: 2
                ),
                PollOption(
                    id: 2,
                    description: "치킨과 떡볶이",
                    imageUrl: "https://gollaba-bucket-dev.s3.ap-northeast-2.amazonaws.com/poll-items/838-2113-e713931e-5bac-4a15-9364-da0818448133.jpg",
                    votingCount: 5
                )
            ]
        )
    }
    
    static func forScreenShotData2() -> PollItem {
        PollItem(
            id: "3",
            title: "강아지 vs 고양이",
            creatorName: "댕댕",
            creatorProfileUrl: nil,
            responseType: "SINGLE",
            pollType: "ANONYMOUS",
            endAt: "2025-03-15T12:00:00",
            readCount: 32,
            votedPeopleCount: 5,
            totalVotingCount: 5,
            items: [
                PollOption(
                    id: 3,
                    description: "강아지",
                    imageUrl: "https://gollaba-bucket-dev.s3.ap-northeast-2.amazonaws.com/poll-items/839-2116-84b2ea93-328b-402d-93cb-860d84ed0d0d.jpg",
                    votingCount: 3
                ),
                PollOption(
                    id: 4,
                    description: "고양이",
                    imageUrl: "https://gollaba-bucket-dev.s3.ap-northeast-2.amazonaws.com/poll-items/839-2115-a2840c4b-dcd3-4bd0-8880-abe6e10f2fe1.jpg",
                    votingCount: 2
                )
            ]
        )
    }
    
    static func forScreenShotData3() -> PollItem {
        PollItem(
            id: "4",
            title: "민초 호불호 조사",
            creatorName: "민초조아",
            creatorProfileUrl: nil,
            responseType: "SINGLE",
            pollType: "ANONYMOUS",
            endAt: "2025-02-24T12:00:00",
            readCount: 19,
            votedPeopleCount: 7,
            totalVotingCount: 7,
            items: [
                PollOption(
                    id: 5,
                    description: "민초 좋아!🥰",
                    imageUrl: nil,
                    votingCount: 2
                ),
                PollOption(
                    id: 6,
                    description: "민초 싫어...😢",
                    imageUrl: nil,
                    votingCount: 5
                )
            ]
        )
    }
}
