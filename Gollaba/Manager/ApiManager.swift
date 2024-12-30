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

enum AuthError: String, Error {
    case notSignUp = "NOT_SIGN_UP"
}

enum VotingError: Error {
    case alreadyVoted
}

enum SortedBy: String {
    case createdAt = "createdAt"
    case endAt = "endAt"
    case none = ""
}

enum ResponseType: String {
    case single = "SINGLE"
    case multiple = "MULTIPLE"
    case none = ""
}

enum PollType: String {
    case named = "NAMED"
    case anonymous = "ANONYMOUS"
    case none = ""
}

enum OptionGroup: String {
    case title = "TITLE"
    case none = ""
}

enum IsActive {
    case active
    case inactive
    case none
    
    var boolValue: Bool {
        switch self {
        case .active:
            return true
        case .inactive:
            return false
        case .none:
            return false
        }
    }
    
    init(boolValue: Bool) {
        self = boolValue ? .active : .inactive
    }
}

enum ProviderType: String {
    case kakao = "KAKAO"
    case google = "GOOGLE"
    case apple = "APPLE"
    case naver = "NAVER"
    case github = "GITHUB"
    case none = ""
}

class ApiManager {
    static let shared = ApiManager()
    let baseURL: String = "https://api.gollaba.app"
    
    let headers: HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
    
    var authManager: AuthManager?
    
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
    
    //MARK: - polls
    // 전체 투표
    func getPolls(
        page: Int = 0,
        size: Int = 10,
        sort: SortedBy = .none,
        pollType: PollType = .none,
        optionGroup: OptionGroup = .none,
        query: String? = nil,
        isActive: IsActive = .none
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
        if isActive != .none {
            queryItems.append("isActive=\(isActive.boolValue)")
        }
        
        let queryString = queryItems.joined(separator: "&")
        let urlString = baseURL + "/v2/polls?" + queryString
        let url = try getUrl(for: urlString)
        
        print("urlString: \(urlString)")
        
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
    
    // 투표 생성
    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async throws -> String {
        let urlString = baseURL + "/v2/polls"
        let url = try getUrl(for: urlString)
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "Accept": "application/json"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let endAtString = dateFormatter.string(from: endAt)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(title.utf8), withName: "title")
                multipartFormData.append(Data(creatorName.utf8), withName: "creatorName")
                multipartFormData.append(Data(responseType.utf8), withName: "responseType")
                multipartFormData.append(Data(pollType.utf8), withName: "pollType")
                multipartFormData.append(Data(endAtString.utf8), withName: "endAt")
                
                //                let itemsArray: [[String: Any]] = items.map { item in
                //                    var jsonObject: [String: Any] = ["description": item.description]
                //
                //                    if let imageData = item.image?.jpegData(compressionQuality: 0.5) {
                //                        jsonObject["image"] = imageData.base64EncodedString()
                //                    } else {
                //                        jsonObject["image"] = nil
                //                    }
                //                    return jsonObject
                //                }
                //
                //
                //                if let itemsData = try? JSONSerialization.data(withJSONObject: itemsArray, options: []) {
                //                    multipartFormData.append(itemsData, withName: "items", mimeType: "application/json")
                //                }
                
                for (index, item) in items.enumerated() {
                    let descriptionField = "items[\(index)].description"
                    multipartFormData.append(Data(item.description.utf8), withName: descriptionField)
                    
                    if let imageData = item.image?.jpegData(compressionQuality: 0.1) {
                        let imageField = "items[\(index)].image"
                        multipartFormData.append(imageData, withName: imageField, fileName: "image\(index + 1).jpg", mimeType: "image/jpeg")
                    }
                }
            }, to: url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DefaultResponse.self) { response in
                switch response.result {
                case .success(let value):
                    Logger.shared.log(String(describing: self), #function, "Success to create poll: \(value)")
                    
                    switch value.data {
                    case .createPollResponseData(let data):
                        continuation.resume(returning: data.id)
                    default:
                        break
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to create poll with error: \(error)", .error)
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
    
    //MARK: - users
    // 유저 이름 수정
    func updateUserName(jwtToken: String, name: String) async throws {
        let urlString = baseURL + "/v2/users"
        let url = try getUrl(for: urlString)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let param: [String: Any] = [
            "name": name
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to update user name: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to update user name with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
        
    
    // 유저 본인 조회
    func getUserMe(jwtToken: String) async throws -> UserData {
        let urlString = baseURL + "/v2/users/me"
        let url = try getUrl(for: urlString)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
                
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get user(me): \(value)")
                        
                        switch value.data {
                        case .userResponseData(let data):
                            continuation.resume(returning: data)
                            
                        default:
                            break
                        }
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get user(me) with error: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    // 회원가입
    func signUp(email: String, name: String, profileImageUrl: String? = nil, providerType: ProviderType, providerAccessToken: String) async throws -> String {
        let urlString = baseURL + "/v2/users/signup"
        let url = try getUrl(for: urlString)
        
        var param: [String: Any] = [
            "email": email,
            "name": name,
            "providerType": providerType.rawValue,
            "providerAccessToken": providerAccessToken
        ]
        
        if let profileImageUrl {
            param["profileImageUrl"] = profileImageUrl
        }
                
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to sign up: \(value)")
                        
                        switch value.data {
                        case .loginResponseData(let data):
                            continuation.resume(returning: data.accessToken)
                        default:
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to sign up with error: \(error)", .error)
                        continuation.resume(with: .failure(error))
                    }
                }
        }
    }
    
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
                        continuation.resume()
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
                        continuation.resume()
                        
                    case .failure(let error):
                        if let data = response.data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                            Logger.shared.log(String(describing: self), #function, "Server error: \(serverError.status)", .error)
                            
                            if serverError.message == "이미 투표하셨습니다." {
                                continuation.resume(throwing: VotingError.alreadyVoted)
                                return
                            }
                        }
                        
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
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to voting check: \(value)")
                        
                        switch value.data {
                        case .boolValue(let data):
                            continuation.resume(returning: data)
                        default:
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to voting check: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    //MARK: - auth
    func loginByProviderToken(providerToken: String, providerType: ProviderType) async throws -> String {
        let providerTypeString = providerType.rawValue
        let urlString = baseURL + "/v2/auth/login/by-provider-token"
        let url = try getUrl(for: urlString)
        let param: [String: Any] = [
            "providerToken": providerToken,
            "providerType": providerTypeString
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to login by provider token: \(value)")
                        
                        switch value.data {
                        case .loginResponseData(let data):
                            continuation.resume(returning: data.accessToken)
                        default:
                            break
                        }
                        
                    case .failure(let error):
                        if let data = response.data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                            Logger.shared.log(String(describing: self), #function, "Server error: \(serverError.status)", .error)
                            
                            if serverError.status == AuthError.notSignUp.rawValue {
                                continuation.resume(throwing: AuthError.notSignUp)
                                return
                            }
                        }
                        Logger.shared.log(String(describing: self), #function, "Failed to login by provider token: \(error)", .error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    //MARK: - Image
    func uploadImage(images: [UIImage]) async throws -> [String] {
        let urlString = baseURL + "/v2/image/upload"
        let url = try getUrl(for: urlString)
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "Accept": "application/json"]
        let filePath: String = "profile-images/"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(Data(filePath.utf8), withName: "filePath")
                    
                    images.enumerated().forEach { index, image in
                        if let imageData = image.jpegData(compressionQuality: 0.1) {
                            multipartFormData.append(
                                imageData,
                                withName: "files",
                                fileName: "image\(index).jpeg",
                                mimeType: "image/jpeg"
                            )
                        }
                    }
                }, to: url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DefaultResponse.self) { response in
                switch response.result {
                case .success(let value):
                    Logger.shared.log(String(describing: self), #function, "Success to upload image: \(value)")
                    
                    switch value.data {
                    case .uploadImageResponseData(let data):
                        continuation.resume(returning: data)
                        
                    default:
                        break
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to upload image with error: \(error)", .error)
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
