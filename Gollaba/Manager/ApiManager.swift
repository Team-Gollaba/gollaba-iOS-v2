//
//  ApiManager.swift
//  Gollaba
//
//  Created by 김견 on 11/27/24.
//

import SwiftUI
import Alamofire

enum ApiError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case invalidParameter
    case invalidRequest
    case invalidResponseData
    case invalidResponseStatusCode
}

enum SortedBy: String {
    case createdAt = "createdAt"
    case endAt = "endAt"
    case none
}

enum ResponseType: String {
    case single = "SINGLE"
    case multiple = "MULTIPLE"
    case none
}

enum PollType: String {
    case named = "NAMED"
    case anonymous = "ANONYMOUS"
    case none
}

enum OptionGroup: String {
    case title = "TITLE"
    case none
}

class ApiManager {
    static let shared = ApiManager()
    let baseURL: String = "https://api.gollaba.app"
    
    let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
    
    //MARK: - polls
    // 전체 투표
    func getPolls(
        page: Int = 0,
        size: Int = 10,
        sort: SortedBy = .none,
        pollType: PollType = .none,
        optionGroup: OptionGroup = .none,
        query: String? = nil,
        isActive: Bool? = nil
    ) async throws -> AllPollData {
        var queryItems: [String] = []
        
        if page != 0 {
            queryItems.append("page=\(page)")
        }
        if size != 10 {
            queryItems.append("size=\(size)")
        }
        if sort != .none {
            queryItems.append("sort=\(sort.rawValue)")
        }
        if pollType != .none {
            queryItems.append("pollType=\(pollType.rawValue)")
        }
        if optionGroup != .none {
            queryItems.append("optionGroup=\(optionGroup.rawValue)")
        }
        if let query = query, !query.isEmpty {
            queryItems.append("query=\(query)")
        }
        if let isActive = isActive {
            queryItems.append("isActive=\(isActive)")
        }
        
        let queryString = queryItems.joined(separator: "&")
        let urlString = baseURL + "/v2/polls?" + queryString
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AllPollResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get polls: \(value)")
                        continuation.resume(returning: value.data)
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get polls with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // 오늘의 투표
    func getTrendingPolls(limit: Int = 10) async throws -> [PollItem] {
        let urlString = baseURL + "/v2/polls/trending?" + "limit=\(limit)"
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PollListResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get trending polls: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get trending polls with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // 인기 투표
    func getTopPolls(limit: Int = 10) async throws -> [PollItem] {
        let urlString = baseURL + "/v2/polls/top?" + "limit=\(limit)"
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PollListResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get top polls: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get top polls with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // 투표 상세 조회
    func getPoll(pollHashId: String) async throws -> PollItem {
        let urlString = baseURL + "/v2/polls/\(pollHashId)"
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PollResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get poll: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get poll with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    //MARK: - user
    // 투표 읽어서 조회수 증가
    func readPoll(pollHashId: String) async throws {
        let urlString = baseURL + "/v2/polls/\(pollHashId)/read"
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to read poll: \(value)")
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to read poll with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    //MARK: - voting
    // 투표 참여
    func voting(pollHashId: String, pollItemIds: [Int], voterName: String?) async throws {
        let urlString = baseURL + "/v2/voting"
        let url = try getUrl(for: urlString)
        var param: [String: Any] = [
            "pollHashId": pollHashId,
            "pollItemIds": pollItemIds
        ]
        
        if let voterName { // 기명 투표
            param["voterName"] = voterName
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to voting: \(value)")
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to voting with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // 투표 참여 여부 확인
    func votingCheck(pollHashId: String) async throws -> Bool {
        let urlString = baseURL + "/v2/voting/check"
        let url = try getUrl(for: urlString)
        let param: [String: Any] = [
            "pollHashId": pollHashId
        ]
        
        print("pollHashId: \(pollHashId)")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to voting check: \(value)")
                        continuation.resume(returning: (value.data != nil))
                        
                        case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to voting check: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func getUrl(for path: String) throws -> URL {
        guard let url = URL(string: path) else {
            Logger.shared.log(String(describing: type(of: self)), #function, "Failed to create URL from path: \(path)")
            
            throw ApiError.invalidURL
        }
        return url
    }
}
