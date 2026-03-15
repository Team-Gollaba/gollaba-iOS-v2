//
//  PollsUseCase.swift
//  Gollaba
//

import Foundation

protocol PollsUseCaseProtocol {
    func getPolls(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getTrendingPolls() async -> Result<[PollItem], NetworkError>
    func getTopPolls() async -> Result<[PollItem], NetworkError>
    func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getPollsFavoriteByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getPollsParticipated(page: Int, size: Int) async -> Result<AllPollData, NetworkError>
    func getPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async -> Result<AllPollData, NetworkError>
    func getTrendingSearchKeywords() async -> Result<[TrendingSearchResponseData], NetworkError>
    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async -> Result<String, NetworkError>
}

class PollsUseCase: PollsUseCaseProtocol {
    private let pollRepository: PollRepositoryProtocol

    init(pollRepository: PollRepositoryProtocol = PollRepositoryImpl()) {
        self.pollRepository = pollRepository
    }

    func getPolls(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        do {
            let data = try await pollRepository.fetchAllPolls(page: page, size: size)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getTrendingPolls() async -> Result<[PollItem], NetworkError> {
        do {
            let data = try await pollRepository.fetchTrendingPolls()
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getTopPolls() async -> Result<[PollItem], NetworkError> {
        do {
            let data = try await pollRepository.fetchTopPolls()
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getPollsCreatedByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        do {
            let data = try await pollRepository.fetchPollsCreatedByMe(page: page, size: size)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getPollsFavoriteByMe(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        do {
            let data = try await pollRepository.fetchPollsFavoriteByMe(page: page, size: size)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getPollsParticipated(page: Int, size: Int) async -> Result<AllPollData, NetworkError> {
        do {
            let data = try await pollRepository.fetchPollsParticipated(page: page, size: size)
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getPolls(page: Int, size: Int, sort: SortedBy, pollType: PollType, optionGroup: OptionGroup, query: String?, isActive: IsActive) async -> Result<AllPollData, NetworkError> {
        do {
            let data = try await pollRepository.fetchPolls(
                page: page, size: size,
                sort: sort, pollType: pollType,
                optionGroup: optionGroup, query: query, isActive: isActive
            )
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func getTrendingSearchKeywords() async -> Result<[TrendingSearchResponseData], NetworkError> {
        do {
            let data = try await pollRepository.fetchTrendingSearchKeywords()
            return .success(data)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }

    func createPoll(title: String, creatorName: String, responseType: String, pollType: String, endAt: Date, items: [PollOptionForParameter]) async -> Result<String, NetworkError> {
        do {
            let id = try await pollRepository.createPoll(
                title: title, creatorName: creatorName,
                responseType: responseType, pollType: pollType,
                endAt: endAt, items: items
            )
            return .success(id)
        } catch {
            return .failure(NetworkError.from(error))
        }
    }
}
