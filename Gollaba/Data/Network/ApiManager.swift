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
    case serverError(status: String, message: String)
    case networkError(Error)
}

enum AuthError: String, Error {
    case notSignUp = "NOT_SIGN_UP"
    case jwtTokenExpired = "JWT_TOKEN_EXPIRED"
    case authManagerIsNil
}

enum VotingError: String, Error {
    case alreadyVoted = "ALREADY_VOTING"
    case alreadyAnonymousVoting = "ALREADY_ANONYMOUS_VOTING"
    case votingNotFound = "VOTING_NOT_FOUND"
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

class ApiManager: ApiManagerProtocol, @unchecked Sendable {
    static let shared = ApiManager()
    let baseURL: String = "https://api.gollaba.app/v2/"

    let headers: HTTPHeaders = ["Content-Type": "application/json"]

    var authManager: AuthManager?
    let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return Session(configuration: configuration, interceptor: ApiInterceptor())
    }()

    init() {}

    func setAuthManager(_ authManager: AuthManager) {
        self.authManager = authManager
    }

    func request<T: Decodable>(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        needAuth: Bool = false
    ) async -> Result<T, NetworkError> {
        var headers: HTTPHeaders = self.headers

        if needAuth {
            guard let jwtToken = authManager?.jwtToken else {
                Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
                return .failure(.notFoundToken)
            }

            headers["Authorization"] = "Bearer \(jwtToken)"
        }

        return await withCheckedContinuation { continuation in
            session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: .success(value))
                    case .failure:
                        let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                        continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                    }
                }
        }
    }

    func uploadMultipart<T: Decodable>(
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders = [:],
        needAuth: Bool = false,
        buildFormData: @escaping (MultipartFormData) -> Void
    ) async -> Result<T, NetworkError> {

        var finalHeaders = headers
        finalHeaders.add(name: "Content-Type", value: "multipart/form-data")

        if needAuth {
            guard let jwtToken = authManager?.jwtToken else {
                Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
                return .failure(.notFoundToken)
            }
            finalHeaders["Authorization"] = "Bearer \(jwtToken)"
        }

        return await withCheckedContinuation { continuation in
            session.upload(multipartFormData: buildFormData, to: url, method: method, headers: finalHeaders)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: .success(value))
                    case .failure:
                        let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                        continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                    }
                }
        }
    }


    //MARK: - app-notifications
    // 푸쉬 알림 등록
    func createAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        guard let jwtToken = authManager?.jwtToken else {
            Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
            return .failure(.notFoundToken)
        }
        let url = getUrl(for: baseURL + "/v2/app-notifications")
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

        return await withCheckedContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to create app notification: \(value)")
                        AppStorageManager.shared.saveToNotificationServerSuccess = true
                        continuation.resume(returning: .success(()))

                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to create app notification with error: \(error)", .error)
                        let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                        continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                    }
                }
        }
    }

    // 푸쉬 알림 수정
    func updateAppPushNotification(agentId: String, allowsNotification: Bool) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/app-notifications")
        let param: Parameters = ["agentId": agentId, "allowsNotification": allowsNotification]
        return await request(url: url, method: .put, parameters: param, needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 푸쉬 알림 내역 조회
    func getPushNotificationHistory(page: Int, size: Int) async -> Result<PushNotificationDatas, NetworkError> {
        var queryItems: [String] = []
        if page != 0 { queryItems.append("page=\(page)") }
        if size != 10 { queryItems.append("size=\(size)") }
        let url = getUrl(for: baseURL + "/v2/app-notifications?" + queryItems.joined(separator: "&"))
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: PushNotificationResponse) in .success(response.data) }
    }


    //MARK: - favorites
    // 좋아요 생성
    func createFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/favorites")
        return await request(url: url, method: .post, parameters: ["pollHashId": pollHashId], needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 좋아요 삭제
    func deleteFavoritePoll(pollHashId: String) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/favorites")
        return await request(url: url, method: .delete, parameters: ["pollHashId": pollHashId], needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 좋아요 목록 조회
    func getFavoritePolls() async -> Result<[String], NetworkError> {
        let url = getUrl(for: baseURL + "/v2/favorites/me")
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: DefaultResponse) in
                guard case .stringListResponseData(let data) = response.data else { return .failure(.invalid) }
                return .success(data)
            }
    }

    //MARK: - polls
    // 전체 투표
    func getPolls(
        page: Int,
        size: Int,
        sort: SortedBy,
        pollType: PollType,
        optionGroup: OptionGroup,
        query: String?,
        isActive: IsActive
    ) async -> Result<AllPollData, NetworkError> {
        var queryItems: [String] = []
        if page != 0 { queryItems.append("page=\(page)") }
        if size != 10 { queryItems.append("size=\(size)") }
        if sort != .none { queryItems.append("sort=\(sort.rawValue),desc") }
        if pollType != .none { queryItems.append("pollType=\(pollType.rawValue)") }
        if optionGroup != .none { queryItems.append("optionGroup=\(optionGroup.rawValue)") }
        if let query, !query.isEmpty { queryItems.append("query=\(query)") }
        if isActive != .none { queryItems.append("isActive=\(isActive.boolValue)") }
        let url = getUrl(for: baseURL + "/v2/polls?" + queryItems.joined(separator: "&"))
        return await request(url: url, method: .get, encoding: URLEncoding.default)
            .flatMap { (response: AllPollResponse) in .success(response.data) }
    }

    // 투표 생성
    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async -> Result<String, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls")
        var headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "Accept": "application/json"]
        if let authManager, authManager.isLoggedIn, let jwtToken = authManager.jwtToken {
            headers["Authorization"] = "Bearer \(jwtToken)"
        } else if authManager?.jwtToken == nil {
            Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
            return .failure(.notFoundToken)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let endAtString = dateFormatter.string(from: endAt)

        return await withCheckedContinuation { continuation in
            session.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data(title.utf8), withName: "title")
                multipartFormData.append(Data(creatorName.utf8), withName: "creatorName")
                multipartFormData.append(Data(responseType.utf8), withName: "responseType")
                multipartFormData.append(Data(pollType.utf8), withName: "pollType")
                multipartFormData.append(Data(endAtString.utf8), withName: "endAt")

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
                        continuation.resume(returning: .success(data.id))
                    default:
                        continuation.resume(returning: .failure(.invalid))
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to create poll with error: \(error)", .error)
                    let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                    continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                }
            }
        }
    }

    // 특정 유저가 좋아요한 투표 전체 조회
    func getPollsFavoriteByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        var queryItems: [String] = ["sort=\(SortedBy.createdAt.rawValue),desc"]
        if page != 0 { queryItems.append("page=\(page)") }
        if size != 10 { queryItems.append("size=\(size)") }
        let url = getUrl(for: baseURL + "/v2/polls/favorites-me?" + queryItems.joined(separator: "&"))
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: AllPollResponse) in .success(response.data) }
    }

    // 특정 유저가 생성한 투표 전체 조회
    func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        var queryItems: [String] = ["sort=\(SortedBy.createdAt.rawValue),desc"]
        if page != 0 { queryItems.append("page=\(page)") }
        if size != 10 { queryItems.append("size=\(size)") }
        let url = getUrl(for: baseURL + "/v2/polls/me?" + queryItems.joined(separator: "&"))
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: AllPollResponse) in .success(response.data) }
    }

    // 인기 검색어
    func getTrendingSearchKeywords() async -> Result<[TrendingSearchResponseData], NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls/search-trending")
        return await request(url: url, method: .get, encoding: URLEncoding.default)
            .flatMap { (response: DefaultResponse) in
                guard case .trendingSearchListResponseData(let data) = response.data else { return .failure(.invalid) }
                return .success(data)
            }
    }

    // 인기 투표
    func getTopPolls(limit: Int) async -> Result<[PollItem], NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls/top?limit=\(limit)")
        return await request(url: url, method: .get, encoding: URLEncoding.default)
            .flatMap { (response: PollListResponse) in .success(response.data) }
    }

    // 오늘의 투표
    func getTrendingPolls(limit: Int) async -> Result<[PollItem], NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls/trending?limit=\(limit)")
        return await request(url: url, method: .get, encoding: URLEncoding.default)
            .flatMap { (response: PollListResponse) in .success(response.data) }
    }

    // 투표 상세 조회
    func getPoll(pollHashId: String) async -> Result<PollItem, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls/\(pollHashId)")
        return await request(url: url, method: .get, encoding: URLEncoding.default)
            .flatMap { (response: PollResponse) in .success(response.data) }
    }

    // 특정 유저가 참여한 투표 전체 조회
    func getPollsParticipated(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        var queryItems: [String] = ["sort=\(SortedBy.createdAt.rawValue),desc"]
        if page != 0 { queryItems.append("page=\(page)") }
        if size != 10 { queryItems.append("size=\(size)") }
        let url = getUrl(for: baseURL + "/v2/voting-polls/me?" + queryItems.joined(separator: "&"))
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: AllPollResponse) in .success(response.data) }
    }

    //MARK: - users
    // 유저 이름 수정
    func updateUserName(name: String) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/users")
        return await request(url: url, method: .put, parameters: ["name": name], needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 유저 프로필 사진 변경
    func updateUserProfileImage(image: UIImage) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/users/change-profile")
        return await uploadMultipart(to: url, needAuth: true) { multipartFormData in
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
        }.map { (_: DefaultResponse) in () }
    }

    // 유저 프로필 사진 제거
    func deleteUserProfileImage() async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/users/delete-profile")
        return await request(url: url, method: .delete, encoding: URLEncoding.default, needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 유저 본인 조회
    func getUserMe() async -> Result<UserData, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/users/me")
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: DefaultResponse) in
                guard case .userResponseData(let data) = response.data else { return .failure(.invalid) }
                return .success(data)
            }
    }

    // 회원탈퇴
    func deleteAccount() async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/users/sign-out")
        return await request(url: url, method: .delete, encoding: URLEncoding.default, needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 회원가입
    func signUp(email: String, name: String, profileImageUrl: String? = nil, providerType: ProviderType, providerAccessToken: String? = nil, providerId: String? = nil) async -> Result<String, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/users/signup")

        var param: [String: Any] = [
            "email": email,
            "name": name,
            "providerType": providerType.rawValue,
        ]
        if let providerAccessToken { param["providerAccessToken"] = providerAccessToken }
        if let providerId { param["providerId"] = providerId }
        if let profileImageUrl { param["profileImageUrl"] = profileImageUrl }

        return await request(url: url, method: .post, parameters: param)
            .flatMap { (response: DefaultResponse) in
                guard case .loginResponseData(let data) = response.data else { return .failure(.invalid) }
                return .success(data.accessToken)
            }
    }

    // 투표 읽어서 조회수 증가
    func readPoll(pollHashId: String) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls/\(pollHashId)/read")
        return await request(url: url, method: .post)
            .map { (_: DefaultResponse) in () }
    }

    //MARK: - voting
    // 투표 참여
    func voting(pollHashId: String, pollItemIds: [Int], voterName: String?) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/voting")
        var param: [String: Any] = [
            "pollHashId": pollHashId,
            "pollItemIds": pollItemIds
        ]
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let authManager, authManager.isLoggedIn, let jwtToken = authManager.jwtToken {
            headers["Authorization"] = "Bearer \(jwtToken)"
        } else if authManager?.jwtToken == nil {
            Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
            return .failure(.notFoundToken)
        }
        if let voterName { param["voterName"] = voterName }

        return await withCheckedContinuation { continuation in
            session.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to voting: \(value)")
                        continuation.resume(returning: .success(()))

                    case .failure(let error):
                        if let data = response.data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                            Logger.shared.log(String(describing: self), #function, "Server error: \(serverError.status)", .error)
                            if serverError.status == VotingError.alreadyVoted.rawValue {
                                continuation.resume(returning: .failure(.requestFailed(serverError.status)))
                                return
                            }
                        }
                        Logger.shared.log(String(describing: self), #function, "Failed to voting with error: \(error)", .error)
                        let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                        continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                    }
                }
        }
    }

    // 투표 참여 여부 확인
    func votingCheck(pollHashId: String) async -> Result<Bool, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/voting/check")
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let authManager, authManager.isLoggedIn, let jwtToken = authManager.jwtToken {
            headers["Authorization"] = "Bearer \(jwtToken)"
        } else if authManager?.jwtToken == nil {
            Logger.shared.log(String(describing: self), #function, "Failed to get JWT token", .error)
            return .failure(.notFoundToken)
        }

        return await withCheckedContinuation { continuation in
            session.request(url, method: .post, parameters: ["pollHashId": pollHashId], encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to voting check: \(value)")
                        switch value.data {
                        case .boolValue(let data):
                            continuation.resume(returning: .success(data))
                        default:
                            continuation.resume(returning: .failure(.invalid))
                        }
                    case .failure(let error):
                        Logger.shared.log(String(describing: self), #function, "Failed to voting check: \(error)", .error)
                        let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                        continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                    }
                }
        }
    }

    // 내 투표 참여 조회
    func getVotingIdByPollHashId(pollHashId: String) async -> Result<VotingIdResponseData, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/voting/me?pollHashId=\(pollHashId)")
        return await request(url: url, method: .get, encoding: URLEncoding.default, needAuth: true)
            .flatMap { (response: DefaultResponse) in
                guard case .votingIdResponseData(let data) = response.data else { return .failure(.invalid) }
                return .success(data)
            }
    }

    // 투표 참여자 이름 조회
    func getVoters(pollHashId: String) async -> Result<[PollVotersResponseData], NetworkError> {
        let url = getUrl(for: baseURL + "/v2/voting/voter?pollHashId=\(pollHashId)")
        return await request(url: url, method: .get, encoding: URLEncoding.default)
            .flatMap { (response: DefaultResponse) in
                guard case .pollVotersResponseData(let data) = response.data else { return .failure(.invalid) }
                return .success(data)
            }
    }

    // 투표 참여 수정
    func updateVote(votingId: Int, voterName: String, pollItemIds: [Int]) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/voting/\(votingId)")
        let param: Parameters = ["voterName": voterName, "pollItemIds": pollItemIds]
        return await request(url: url, method: .put, parameters: param, needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    // 투표 참여 철회
    func cancelVote(votingId: Int) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/voting/\(votingId)")
        return await request(url: url, method: .delete, encoding: URLEncoding.default, needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    //MARK: - Auth
    // 토큰 갱신
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        let url = getUrl(for: baseURL + "/v2/auth/renew-token")

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
    func loginByProviderToken(providerToken: String, providerType: ProviderType) async -> Result<String, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/auth/login/by-provider-token")
        let param: [String: Any] = [
            "providerToken": providerToken,
            "providerType": providerType.rawValue
        ]

        return await withCheckedContinuation { continuation in
            AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DefaultResponse.self) { response in
                    switch response.result {
                    case .success(let value):
                        Logger.shared.log(String(describing: self), #function, "Success to login by provider token: \(value)")
                        switch value.data {
                        case .loginResponseData(let data):
                            continuation.resume(returning: .success(data.accessToken))
                        default:
                            continuation.resume(returning: .failure(.invalid))
                        }

                    case .failure(let error):
                        if let data = response.data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                            Logger.shared.log(String(describing: self), #function, "Server error: \(serverError.status)", .error)
                            if serverError.status == AuthError.notSignUp.rawValue {
                                continuation.resume(returning: .failure(.requestFailed(serverError.status)))
                                return
                            }
                        }
                        Logger.shared.log(String(describing: self), #function, "Failed to login by provider token: \(error)", .error)
                        let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                        continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                    }
                }
        }
    }

    //MARK: - Image
    func uploadImage(images: [UIImage]) async -> Result<[String], NetworkError> {
        let url = getUrl(for: baseURL + "/v2/image/upload")
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "Accept": "application/json"]
        let filePath: String = "profile-images/"

        return await withCheckedContinuation { continuation in
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
                        continuation.resume(returning: .success(data))
                    default:
                        continuation.resume(returning: .failure(.invalid))
                    }
                case .failure(let error):
                    Logger.shared.log(String(describing: self), #function, "Failed to upload image with error: \(error)", .error)
                    let errorMessage = self.getServerErrorIncludeMessage(data: response.data)
                    continuation.resume(returning: .failure(.requestFailed(errorMessage)))
                }
            }
        }
    }

    //MARK: - Report
    func reportPoll(pollHashId: String, content: String, reportType: ReportType) async -> Result<Void, NetworkError> {
        let url = getUrl(for: baseURL + "/v2/polls/\(pollHashId)/reports")
        let param: Parameters = ["content": content, "reportType": reportType.rawValue]
        return await request(url: url, method: .post, parameters: param, needAuth: true)
            .map { (_: DefaultResponse) in () }
    }

    //MARK: - ETC
    func getUrl(for path: String) -> URL {
        guard let url = URL(string: path) else {
            Logger.shared.log(String(describing: type(of: self)), #function, "Failed to create URL from path: \(path)", .error)
            return URL(string: "")!
        }
        return url
    }

    func getServerErrorIncludeMessage(data: Data?) -> String {
        if let data, let serverError = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
            return serverError.message
        } else {
            return "Unknown server error"
        }
    }
}
