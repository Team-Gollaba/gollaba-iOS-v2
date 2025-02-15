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
    case invalidURL
    case serverError(message: String)
    case networkError(Error)
}

enum AuthError: String, Error {
    case notSignUp = "NOT_SIGN_UP"
    case jwtTokenExpired = "JWT_TOKEN_EXPIRED"
    case authManagerIsNil
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
    
    let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    var authManager: AuthManager?
    let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return Session(configuration: configuration, interceptor: ApiInterceptor())
    }()
    
    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }
    
    //MARK: - app-notifications
    // 푸쉬 알림 등록
    func createAppPushNotification(agentId: String, allowsNotification: Bool) async throws {
        let urlString = baseURL + "/v2/app-notifications"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        let deviceName = await UIDevice.current.name
        let param: [String: Any] = [
            "agentId": agentId,
            "osType": "IOS",
            "deviceName": deviceName,
            "allowsNotification": allowsNotification
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to create app notification: \(value)")
                        AppStorageManager.shared.saveToNotificationServerSuccess = true
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to create app notification with error: \(error)", .error)
                        
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 푸쉬 알림 수정
    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async throws {
        let urlSting = baseURL + "/v2/app-notifications"
        let url = try getUrl(for: urlSting)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        let param: [String: Any] = [
            "agentId": agentId,
            "allowsNotification": allowsNotification
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to update app notification: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to update app notification with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 푸쉬 알림 내역 조회
    func getPushNotificationHistory(page: Int = 0, size: Int = 10) async throws -> PushNotificationDatas {
        var queryItems: [String] = []
        
        if page != 0 {
            queryItems.append("page=\(page)")
        }
        if size != 10 {
            queryItems.append("size=\(size)")
        }
        let queryString = queryItems.joined(separator: "&")
        let urlString = baseURL + "/v2/app-notifications" + "?" + queryString
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        print("urlString: \(urlString), headers: \(headers), jwtToken: \(jwtToken)")
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PushNotificationResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get push notification history: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get push notification history with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
        
    
    // [TEMP] 푸쉬 알림 메시지 전송
    func sendPushNotification(title: String, content: String) async throws {
        let urlString = baseURL + "/v2/server-message"
        let url = try getUrl(for: urlString)
        let param: [String: Any] = [
            "title": title,
            "content": content
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to send push notification: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Faild to send push notification with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
        
    
    //MARK: - favorites
    // 좋아요 생성
    func createFavoritePoll(pollHashId: String) async throws {
        let urlString = baseURL + "/v2/favorites"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        let param: [String: Any] = [
            "pollHashId": pollHashId
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to create favorite poll: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to create favorite poll with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 좋아요 삭제
    func deleteFavoritePoll(pollHashId: String) async throws {
        let urlString = baseURL + "/v2/favorites"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        let param: [String: Any] = [
            "pollHashId": pollHashId
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .delete, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to delete favorite poll: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to delete favorite poll with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 좋아요 목록 조회
    func getFavoritePolls() async throws {
        let urlString = baseURL + "/v2/favorites/me"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get favorite polls: \(value)")
                        
                        switch value.data {
                        case .stringListResponseData(let data):
                            if let authManager = self.authManager {
                                authManager.favoritePolls = data
                            } else {
                                Logger.shared.log(String(describing: self), #function, "Favorite polls is nil", .error)
                            }
                            continuation.resume()
                            
                        default:
                            Logger.shared.log(String(describing: self), #function, "Failed to get favorite polls with invalid response", .error)
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get favorite polls with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
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
        let urlString = baseURL + "/v2/polls" + "?" + queryString
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
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 투표 생성
    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async throws -> String {
        let urlString = baseURL + "/v2/polls"
        let url = try getUrl(for: urlString)
        var headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "Accept": "application/json"]
        if let authManager, authManager.isLoggedIn, let jwtToken = authManager.jwtToken {
            headers["Authorization"] = "Bearer \(jwtToken)"
        }
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let endAtString = dateFormatter.string(from: endAt)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(multipartFormData: { multipartFormData in
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
                        continuation.resume(throwing: ApiError.invalidResponse)
                        break
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to create poll with error: \(error)", .error)
                    continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                }
            }
        }
    }
    
    // 특정 유저가 좋아요한 투표 전체 조회
    func getPollsFavoriteByMe(page: Int = 0, size: Int = 10) async throws -> AllPollData {
        var queryItems: [String] = [
            "sort=\(SortedBy.createdAt.rawValue),desc"
        ]
        
        if page != 0 {
            queryItems.append("page=\(page)")
        }
        if size != 10 {
            queryItems.append("size=\(size)")
        }
        let queryString = queryItems.joined(separator: "&")
        let urlString = baseURL + "/v2/polls/favorites-me" + "?" + queryString
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AllPollResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get polls favorite by me: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get polls favorite by me with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 특정 유저가 생성한 투표 전체 조회
    func getPollsCreatedByMe(page: Int = 0, size: Int = 10) async throws -> AllPollData {
        var queryItems: [String] = [
            "sort=\(SortedBy.createdAt.rawValue),desc"
        ]
        
        if page != 0 {
            queryItems.append("page=\(page)")
        }
        if size != 10 {
            queryItems.append("size=\(size)")
        }
        let queryString = queryItems.joined(separator: "&")
        let urlString = baseURL + "/v2/polls/me" + "?" + queryString
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AllPollResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get polls created by me: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get polls created by me with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 인기 검색어
    func getTrendingSearchKeywords() async throws -> [TrendingSearchResponseData] {
        let urlString = baseURL + "/v2/polls/search-trending"
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get top keywords: \(value)")
                        
                        switch value.data {
                        case .trendingSearchListResponseData(let data):
                            continuation.resume(returning: data)
                            
                        default:
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get top keywords with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
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
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
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
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
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
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 특정 유저가 참여한 투표 전체 조회
    func getPollsParticipated(page: Int = 0, size: Int = 10) async throws -> AllPollData {
        var queryItems: [String] = [
            "sort=\(SortedBy.createdAt.rawValue),desc"
        ]
        
        if page != 0 {
            queryItems.append("page=\(page)")
        }
        if size != 10 {
            queryItems.append("size=\(size)")
        }
        let queryString = queryItems.joined(separator: "&")
        let urlString = baseURL + "/v2/voting-polls/me" + "?" + queryString
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
                
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AllPollResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get polls participated: \(value)")
                        continuation.resume(returning: value.data)
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get polls participated with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    //MARK: - users
    // 유저 이름 수정
    func updateUserName(name: String) async throws {
        let urlString = baseURL + "/v2/users"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        let param: [String: Any] = [
            "name": name
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to update user name: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to update user name with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 유저 프로필 사진 변경
    func updateUserProfileImage(image: UIImage) async throws {
        let urlString = baseURL + "/v2/users/change-profile"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(
                multipartFormData: { multipartFormData in
                    if let imageData = image.jpegData(compressionQuality: 0.1) {
                        let imageField = "image"
                        multipartFormData.append(imageData, withName: imageField, fileName: "image.jpeg", mimeType: "image/jpeg")
                    }
                }, to: url, headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DefaultResponse.self) { response in
                switch response.result {
                case .success(let value):
                    Logger.shared.log(String(describing: self), #function, "Success to update user profile image: \(value)")
                    continuation.resume()
                    
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to update user profile image with error: \(error)", .error)
                    continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                }
            }
        }
    }
        
    // 유저 프로필 사진 제거
    func deleteUserProfileImage() async throws {
        let urlString = baseURL + "/v2/users/delete-profile"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .delete, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to delete user profile image: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to delete user profile image with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 유저 본인 조회
    func getUserMe() async throws -> UserData {
        let urlString = baseURL + "/v2/users/me"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
                        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get user(me): \(value)")
                        
                        switch value.data {
                        case .userResponseData(let data):
                            continuation.resume(returning: data)
                            
                        default:
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get user(me) with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 회원탈퇴
    func deleteAccount() async throws {
        let urlString = baseURL + "/v2/users/sign-out"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .delete, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to delete account: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to delete account with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 회원가입
    func signUp(email: String, name: String, profileImageUrl: String? = nil, providerType: ProviderType, providerAccessToken: String? = nil, providerId: String? = nil) async throws -> String {
        let urlString = baseURL + "/v2/users/signup"
        let url = try getUrl(for: urlString)
        
        var param: [String: Any] = [
            "email": email,
            "name": name,
            "providerType": providerType.rawValue,
        ]
        
        if let providerAccessToken {
            param["providerAccessToken"] = providerAccessToken
        }
        
        if let providerId {
            param["providerId"] = providerId
        }
        
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
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to sign up with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
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
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
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
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let authManager, authManager.isLoggedIn {
            let jwtToken = try getJwtToken()
            headers["Authorization"] = "Bearer \(jwtToken)"
        }
        
        if let voterName { // 기명 투표
            param["voterName"] = voterName
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 투표 참여 여부 확인
    func votingCheck(pollHashId: String) async throws -> Bool {
        let urlString = baseURL + "/v2/voting/check"
        let url = try getUrl(for: urlString)
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let authManager, authManager.isLoggedIn {
            let jwtToken = try getJwtToken()
            headers["Authorization"] = "Bearer \(jwtToken)"
        }
        let param: [String: Any] = [
            "pollHashId": pollHashId
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to voting check: \(value)")
                        
                        switch value.data {
                        case .boolValue(let data):
                            continuation.resume(returning: data)
                        default:
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to voting check: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 내 투표 참여 조회
    func getVotingIdByPollHashId(pollHashId: String) async throws -> VotingIdResponseData {
        let urlString = baseURL + "/v2/voting/me" + "?pollHashId=\(pollHashId)"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
                
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get voting id: \(value)")
                        
                        switch value.data {
                        case .votingIdResponseData(let data):
                            continuation.resume(returning: data)
                        default:
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get voting id with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 투표 참여자 이름 조회
    func getVoters(pollHashId: String) async throws -> [PollVotersResponseData] {
        let urlString = baseURL + "/v2/voting/voter" + "?pollHashId=\(pollHashId)"
        let url = try getUrl(for: urlString)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to get voters: \(value)")
                        
                        switch value.data {
                        case .pollVotersResponseData(let data):
                            continuation.resume(returning: data)
                        default:
                            continuation.resume(throwing: ApiError.invalidResponse)
                        }
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to get voters with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 투표 참여 수정
    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async throws {
        let urlString = baseURL + "/v2/voting/\(votingId)"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        let param: [String: Any] = [
            "voterName": voterName,
            "pollItemIds": pollItemIds
        ]
                
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to update vote: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to update vote with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    // 투표 참여 철회
    func cancelVote(votingId: Int) async throws {
        let urlString = baseURL + "/v2/voting/\(votingId)"
        let url = try getUrl(for: urlString)
        let jwtToken = try getJwtToken()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(jwtToken)",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .delete, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to cancel vote: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to cancel vote with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    //MARK: - Auth
    // 토큰 갱신
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) throws {
        let urlString = baseURL + "/v2/auth/renew-token"
        let url = try getUrl(for: urlString)
        
        AF.request(url, method: .post, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DefaultResponse.self) { response in
                switch response.result {
                case .success(let value):
                    Logger.shared.log(String(describing: self), #function, "Success to refresh token: \(value)")
                    
                    switch value.data {
                    case .loginResponseData(let data):
                        self.authManager?.jwtToken = data.accessToken
                        completion(.success(data.accessToken))
                    default:
                        completion(.failure(ApiError.invalidResponse))
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to refresh token with error: \(error)", .error)
                    completion(.failure(error))
                }
            }
        
    }
    
    // OAuth 로그인
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
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            for cookie in cookies {
                                print("쿠키 이름: \(cookie.name), 값: \(cookie.value)")
                            }
                        }
                        
                        switch value.data {
                        case .loginResponseData(let data):
                            continuation.resume(returning: data.accessToken)
                        default:
                            continuation.resume(throwing: ApiError.invalidResponse)
                            break
                        }
                        
                    case .failure(let error):
                        if let data = response.data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                            Logger.shared.log(String(describing: self), #function, "Server error: \(serverError.status)", .error)
                            
                            if serverError.status == AuthError.notSignUp.rawValue {
                                continuation.resume(throwing: AuthError.notSignUp)
                                return
                            } else {
                                continuation.resume(throwing: ApiError.serverError(message: serverError.message))
                            }
                        }
                        Logger.shared.log(String(describing: self), #function, "Failed to login by provider token: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
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
                    case .stringListResponseData(let data):
                        continuation.resume(returning: data)
                        
                    default:
                        continuation.resume(throwing: ApiError.invalidResponse)
                        break
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to upload image with error: \(error)", .error)
                    continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                }
            }
        }
    }
    
    //MARK: - Report
    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async throws {
        let urlString = baseURL + "/v2/polls/\(pollHashId)/reports"
        let url = try getUrl(for: urlString)
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let authManager, authManager.isLoggedIn {
            let jwtToken = try getJwtToken()
            headers["Authorization"] = "Bearer \(jwtToken)"
        }
        let param: [String: Any] = [
            "content": content,
            "reportType": reportType.rawValue
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to report poll: \(value)")
                        continuation.resume()
                        
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to report poll with error: \(error)", .error)
                        continuation.resume(throwing: self.getServerErrorIncludeMessage(data: response.data))
                    }
                }
        }
    }
    
    //MARK: - ETC
    func getUrl(for path: String) throws -> URL {
        guard let url = URL(string: path) else {
            Logger.shared.log(String(describing: type(of: self)), #function, "Failed to create URL from path: \(path)", .error)
            
            throw ApiError.invalidURL
        }
        return url
    }
    
    func getJwtToken() throws -> String {
        guard let token = authManager?.jwtToken else {
            Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
            
            throw AuthError.jwtTokenExpired
        }
        return token
    }
    
    func getServerErrorIncludeMessage(data: Data?) -> Error {
        if let data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
            return ApiError.serverError(message: serverError.message)
        } else {
            return ApiError.serverError(message: "Unknown server error")
        }
    }
}
