@testable import Gollaba
import XCTest

final class DefaultUserRepositoryTests: XCTestCase {
    private var sut: DefaultUserRepository!
    private var mockApiManager: MockApiManager!

    override func setUp() {
        super.setUp()
        mockApiManager = MockApiManager()
        sut = DefaultUserRepository(apiManager: mockApiManager)
    }

    override func tearDown() {
        sut = nil
        mockApiManager = nil
        super.tearDown()
    }

    // MARK: - fetchUserMe

    func test_getUserMe_성공시_UserData_반환() async throws {
        // given
        let expectedUser = UserData(
            name: "테스터",
            email: "test@test.com",
            roleType: "USER",
            providerType: "KAKAO",
            profileImageUrl: nil,
            backgroundImageUrl: nil
        )
        mockApiManager.getUserMeResult = .success(expectedUser)

        // when
        let result = try await sut.fetchUserMe()

        // then
        XCTAssertEqual(result.name, "테스터")
        XCTAssertEqual(result.email, "test@test.com")
    }

    func test_getUserMe_실패시_에러_throw() async {
        // given
        mockApiManager.getUserMeResult = .failure(.notFoundToken)

        // when / then
        do {
            _ = try await sut.fetchUserMe()
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, NetworkError.notFoundToken.description)
        }
    }

    func test_getUserMe_ApiManager_1회_호출() async throws {
        // given
        let user = UserData(
            name: "테스터",
            email: "test@test.com",
            roleType: "USER",
            providerType: "KAKAO",
            profileImageUrl: nil,
            backgroundImageUrl: nil
        )
        mockApiManager.getUserMeResult = .success(user)

        // when
        _ = try await sut.fetchUserMe()

        // then
        XCTAssertEqual(mockApiManager.getUserMeCallCount, 1)
    }

    // MARK: - updateName

    func test_updateUserName_성공시_에러없음() async throws {
        // given
        mockApiManager.updateUserNameResult = .success(())

        // when / then (에러 없이 완료)
        try await sut.updateName(name: "새이름")
        XCTAssertEqual(mockApiManager.updateUserNameCallCount, 1)
    }

    func test_updateUserName_실패시_에러_throw() async {
        // given
        mockApiManager.updateUserNameResult = .failure(.requestFailed("이름 변경 실패"))

        // when / then
        do {
            try await sut.updateName(name: "새이름")
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "이름 변경 실패")
        }
    }

    func test_updateUserName_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.updateUserNameResult = .success(())

        // when
        try await sut.updateName(name: "새이름")

        // then
        XCTAssertEqual(mockApiManager.updateUserNameCallCount, 1)
    }

    // MARK: - deleteAccount

    func test_deleteAccount_성공시_에러없음() async throws {
        // given
        mockApiManager.deleteAccountResult = .success(())

        // when / then (에러 없이 완료)
        try await sut.deleteAccount()
        XCTAssertEqual(mockApiManager.deleteAccountCallCount, 1)
    }

    func test_deleteAccount_실패시_에러_throw() async {
        // given
        mockApiManager.deleteAccountResult = .failure(.requestFailed("탈퇴 실패"))

        // when / then
        do {
            try await sut.deleteAccount()
            XCTFail("에러를 기대했으나 성공")
        } catch {
            XCTAssertEqual((error as? NetworkError)?.description, "탈퇴 실패")
        }
    }

    func test_deleteAccount_ApiManager_1회_호출() async throws {
        // given
        mockApiManager.deleteAccountResult = .success(())

        // when
        try await sut.deleteAccount()

        // then
        XCTAssertEqual(mockApiManager.deleteAccountCallCount, 1)
    }
}
