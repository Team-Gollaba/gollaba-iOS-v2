//
//  ApiInterceptor.swift
//  Gollaba
//
//  Created by 김견 on 1/23/25.
//

import Foundation
import Alamofire

final class ApiInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        if ApiManager.shared.authManager?.isLoggedIn ?? false,
           let token = ApiManager.shared.authManager?.jwtToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        ApiManager.shared.refreshToken { result in
            switch result {
            case .success(let newToken):
                Logger.shared.log(String(describing: self), #function, "Success to refresh token")
                ApiManager.shared.authManager?.jwtToken = newToken
                completion(.retry)
            case .failure(let error):
                Logger.shared.log(String(describing: self), #function, "Failed to refresh token: \(error)", .error)
                ApiManager.shared.authManager?.sessionExpired = true
                Task { await ApiManager.shared.authManager?.logout() }
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
