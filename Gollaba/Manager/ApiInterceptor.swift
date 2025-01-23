//
//  ApiInterceptor.swift
//  Gollaba
//
//  Created by 김견 on 1/23/25.
//

import Foundation
import Alamofire

final class ApiInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        do {
            try ApiManager.shared.refreshToken { result in
                switch result {
                case .success(let newToken):
                    var request = request.request
                    request?.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
        } catch {
            completion(.doNotRetryWithError(error))
        }
    }
}
