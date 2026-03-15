//
//  MainViewModel.swift
//  Gollaba
//
//  Created by 김견 on 11/13/24.
//

import SwiftUI

@MainActor
@Observable
class MainViewModel {
    var goToLogin = false
    var goToDetailView: Bool = false
    var pollHashIdFromURL: String? = nil
    var authManager: AuthManager?
    static let shared = MainViewModel()

    private let userUseCase: UserUseCaseProtocol

    init(userUseCase: UserUseCaseProtocol = UserUseCase()) {
        self.userUseCase = userUseCase
    }

    func getUserMe() async {
        let result = await userUseCase.getUserMe()
        switch result {
        case .success(let userData):
            authManager?.userData = userData
        case .failure(let error):
            Logger.shared.log(String(describing: self), #function, "Failed to get userMe with error: \(error)")
        }
    }

    func handleUniversalLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        let pathComponents = components.path.split(separator: "/")

        if pathComponents.count >= 3, pathComponents[0] == "voting", pathComponents[1] == "pollHashId" {
            let pollHashId = String(pathComponents[2])
            pollHashIdFromURL = pollHashId
            Logger.shared.log(String(describing: self), #function, "pollHashIdFromURL: \(pollHashId)")
            goToDetailView = true
        }
    }
}
