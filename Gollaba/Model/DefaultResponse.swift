//
//  DefaultResponse.swift
//  Gollaba
//
//  Created by 김견 on 11/29/24.
//

import Foundation

enum DataType: Codable {
    case boolValue(Bool)
    case createPollResponseData(CreatePollResponseData)
    case loginResponseData(LoginResponseData)
    case stringListResponseData([String])
    case userResponseData(UserData)
    case favoritePollResponseData(CreateFavoritePollResponseData)
    case trendingSearchListResponseData([TrendingSearchResponseData])
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let boolValue = try? container.decode(Bool.self) {
            self = .boolValue(boolValue)
        } else if let createPollResponseData = try? container.decode(CreatePollResponseData.self) {
            self = .createPollResponseData(createPollResponseData)
        } else if let loginResponseData = try? container.decode(LoginResponseData.self) {
            self = .loginResponseData(loginResponseData)
        } else if let uploadImageResponseData = try? container.decode([String].self) {
            self = .stringListResponseData(uploadImageResponseData)
        } else if let userResponseData = try? container.decode(UserData.self) {
            self = .userResponseData(userResponseData)
        } else if let favoritePollResponseData = try? container.decode(CreateFavoritePollResponseData.self) {
            self = .favoritePollResponseData(favoritePollResponseData)
        } else if let trendingSearchListResponseData = try? container.decode([TrendingSearchResponseData].self) {
            self = .trendingSearchListResponseData(trendingSearchListResponseData)
        }
        else {
            throw DecodingError.typeMismatch(DataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Bool value"))
        }
    }
}

struct DefaultResponse: Codable {
    let status: String
    let message: String
    let serverDateTime: String
    let data: DataType?
}

struct CreatePollResponseData: Codable {
    let id: String
}

struct LoginResponseData: Codable {
    let accessToken: String
}

struct CreateFavoritePollResponseData: Codable {
    let id: Int
}

struct TrendingSearchResponseData: Codable {
    let searchedWord: String
    let searchCount: Int
}
