//
//  AppContainer.swift
//  Gollaba
//

import Factory

// MARK: - UseCases (singleton 스코프 — 앱 전체에서 공유)
extension Container {
    var pollsUseCase: Factory<PollsUseCaseProtocol> {
        self { PollsUseCase() }.singleton
    }
    var favoriteUseCase: Factory<FavoriteUseCaseProtocol> {
        self { FavoriteUseCase() }.singleton
    }
    var userUseCase: Factory<UserUseCaseProtocol> {
        self { UserUseCase() }.singleton
    }
    var authUseCase: Factory<AuthUseCaseProtocol> {
        self { AuthUseCase() }.singleton
    }
    var pushNotificationUseCase: Factory<PushNotificationUseCaseProtocol> {
        self { PushNotificationUseCase() }.singleton
    }
    var votingUseCase: Factory<VotingUseCaseProtocol> {
        self { VotingUseCase() }.singleton
    }
}

// MARK: - ViewModels (호출마다 새 인스턴스)
extension Container {
    var homeViewModel: Factory<HomeViewModel> {
        self { HomeViewModel(pollsUseCase: self.pollsUseCase()) }
    }
    var myPollViewModel: Factory<MyPollViewModel> {
        self { MyPollViewModel(
            pollsUseCase: self.pollsUseCase(),
            favoriteUseCase: self.favoriteUseCase(),
            pushNotificationUseCase: self.pushNotificationUseCase(),
            userUseCase: self.userUseCase()
        )}
    }
    var searchViewModel: Factory<SearchViewModel> {
        self { SearchViewModel(pollsUseCase: self.pollsUseCase()) }
    }
    var loginViewModel: Factory<LoginViewModel> {
        self { LoginViewModel(authUseCase: self.authUseCase()) }
    }
    var signUpViewModel: Factory<SignUpViewModel> {
        self { SignUpViewModel(authUseCase: self.authUseCase()) }
    }
    var createPollViewModel: Factory<CreatePollViewModel> {
        self { CreatePollViewModel(pollsUseCase: self.pollsUseCase()) }
    }
    var notificationViewModel: Factory<NotificationViewModel> {
        self { NotificationViewModel(pushNotificationUseCase: self.pushNotificationUseCase()) }
    }
    var settingViewModel: Factory<SettingViewModel> {
        self { SettingViewModel(
            pushNotificationUseCase: self.pushNotificationUseCase(),
            userUseCase: self.userUseCase()
        )}
    }
    // 런타임 파라미터 필요한 ViewModel → ParameterFactory
    var pollDetailViewModel: ParameterFactory<String, PollDetailViewModel> {
        self { id in PollDetailViewModel(
            id: id,
            votingUseCase: self.votingUseCase(),
            favoriteUseCase: self.favoriteUseCase()
        )}
    }
    var searchResultListViewModel: ParameterFactory<String, SearchResultListViewModel> {
        self { query in SearchResultListViewModel(
            query: query,
            pollsUseCase: self.pollsUseCase()
        )}
    }
}
