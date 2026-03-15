@testable import Gollaba
import XCTest

final class UserUseCaseTests: XCTestCase {
    private var sut: UserUseCase!
    private var mockRepository: MockUserRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        sut = UserUseCase(userRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - getUserMe

    func test_getUserMe_성공시_UserData_반환() async {
        // given
        let expected = UserData(name: "김견", email: "kim@test.com", roleType: "USER", providerType: "APPLE", profileImageUrl: nil, backgroundImageUrl: nil)
        mockRepository.fetchUserMeResult = .success(expected)

        // when
        let result = await sut.getUserMe()

        // then
        if case .success(let userData) = result {
            XCTAssertEqual(userData.name, "김견")
            XCTAssertEqual(userData.email, "kim@test.com")
        } else {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }

    func test_getUserMe_실패시_NetworkError_반환() async {
        // given
        mockRepository.fetchUserMeResult = .failure(NetworkError.notFoundToken)

        // when
        let result = await sut.getUserMe()

        // then
        if case .failure(let error) = result {
            XCTAssertEqual(error.description, NetworkError.notFoundToken.description)
        } else {
            XCTFail("실패 결과를 기대했으나 성공")
        }
    }

    // MARK: - updateUserName

    func test_updateUserName_성공시_success_반환() async {
        // given
        mockRepository.updateNameResult = .success(())

        // when
        let result = await sut.updateUserName(name: "새이름")

        // then
        if case .failure = result {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }

    func test_updateUserName_실패시_NetworkError_반환() async {
        // given
        mockRepository.updateNameResult = .failure(NetworkError.requestFailed("이름 변경 실패"))

        // when
        let result = await sut.updateUserName(name: "새이름")

        // then
        if case .failure(let error) = result {
            XCTAssertEqual(error.description, "이름 변경 실패")
        } else {
            XCTFail("실패 결과를 기대했으나 성공")
        }
    }

    // MARK: - deleteAccount

    func test_deleteAccount_성공시_success_반환() async {
        // given
        mockRepository.deleteAccountResult = .success(())

        // when
        let result = await sut.deleteAccount()

        // then
        if case .failure = result {
            XCTFail("성공 결과를 기대했으나 실패")
        }
    }
}
