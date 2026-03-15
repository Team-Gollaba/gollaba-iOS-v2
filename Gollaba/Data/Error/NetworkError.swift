//
//  NetworkError.swift
//  Gollaba
//

import Foundation

enum NetworkError: Error {
    case notFoundToken
    case requestFailed(String)
    case invalid

    var description: String {
        switch self {
        case .notFoundToken:
            return "인증 토큰을 찾을 수 없습니다."
        case .requestFailed(let message):
            return message
        case .invalid:
            return "잘못된 응답입니다."
        }
    }

    static func from(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        return .requestFailed(error.localizedDescription)
    }
}

// MARK: - Server Status Codes
extension NetworkError {
    static let notSignUpStatus = "NOT_SIGN_UP"
    static let alreadyVotedStatus = "ALREADY_VOTING"
}
