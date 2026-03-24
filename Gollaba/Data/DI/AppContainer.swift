//
//  AppContainer.swift
//  Gollaba
//

import Factory

// MARK: - ApiManager (singleton)
extension Container {
    var apiManager: Factory<any ApiManagerProtocol> {
        self { ApiManager.shared }.singleton
    }
}

// MARK: - Repositories (singleton)
extension Container {
    var pollRepository: Factory<any PollRepository> {
        self { DefaultPollRepository(apiManager: self.apiManager()) }.singleton
    }
    var favoriteRepository: Factory<any FavoriteRepository> {
        self { DefaultFavoriteRepository(apiManager: self.apiManager()) }.singleton
    }
    var userRepository: Factory<any UserRepository> {
        self { DefaultUserRepository(apiManager: self.apiManager()) }.singleton
    }
    var authRepository: Factory<any AuthRepository> {
        self { DefaultAuthRepository(apiManager: self.apiManager()) }.singleton
    }
    var votingRepository: Factory<any VotingRepository> {
        self { DefaultVotingRepository(apiManager: self.apiManager()) }.singleton
    }
    var notificationRepository: Factory<any NotificationRepository> {
        self { DefaultNotificationRepository(apiManager: self.apiManager()) }.singleton
    }
}

// MARK: - UseCases (singleton)
extension Container {
    var pollsUseCase: Factory<PollsUseCaseProtocol> {
        self { PollsUseCase(pollRepository: self.pollRepository()) }.singleton
    }
    var favoriteUseCase: Factory<FavoriteUseCaseProtocol> {
        self { FavoriteUseCase(favoriteRepository: self.favoriteRepository()) }.singleton
    }
    var userUseCase: Factory<UserUseCaseProtocol> {
        self { UserUseCase(userRepository: self.userRepository()) }.singleton
    }
    var authUseCase: Factory<AuthUseCaseProtocol> {
        self { AuthUseCase(authRepository: self.authRepository()) }.singleton
    }
    var pushNotificationUseCase: Factory<PushNotificationUseCaseProtocol> {
        self { PushNotificationUseCase(notificationRepository: self.notificationRepository()) }.singleton
    }
    var votingUseCase: Factory<VotingUseCaseProtocol> {
        self { VotingUseCase(votingRepository: self.votingRepository()) }.singleton
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
    var mainViewModel: Factory<MainViewModel> {
        self { MainViewModel(userUseCase: self.userUseCase()) }.singleton
    }
}
