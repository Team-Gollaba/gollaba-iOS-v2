@testable import Gollaba
import UIKit
import XCTest

@MainActor
final class CreatePollViewModelTests: XCTestCase {
    private var sut: CreatePollViewModel!
    private var mockUseCase: MockPollsUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockPollsUseCase()
        sut = CreatePollViewModel(pollsUseCase: mockUseCase)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }

    // MARK: - isValidForCreatePoll

    func test_isValidForCreatePoll_모든필드_입력시_true() {
        // given
        sut.creatorNameText = "테스터"
        sut.titleText = "투표 제목"
        sut.pollItemName = ["항목1", "항목2", "항목3"]
        sut.selectedDate = Date().addingTimeInterval(60 * 60)

        // when & then
        XCTAssertTrue(sut.isValidForCreatePoll())
    }

    func test_isValidForCreatePoll_제목_비어있으면_false() {
        // given
        sut.creatorNameText = "테스터"
        sut.titleText = ""
        sut.pollItemName = ["항목1", "항목2", "항목3"]

        // when & then
        XCTAssertFalse(sut.isValidForCreatePoll())
    }

    func test_isValidForCreatePoll_생성자이름_비어있으면_false() {
        // given
        sut.creatorNameText = ""
        sut.titleText = "투표 제목"
        sut.pollItemName = ["항목1", "항목2", "항목3"]

        // when & then
        XCTAssertFalse(sut.isValidForCreatePoll())
    }

    func test_isValidForCreatePoll_항목_비어있으면_false() {
        // given - pollItemName.dropLast() 에 빈 문자열 포함
        sut.creatorNameText = "테스터"
        sut.titleText = "투표 제목"
        sut.pollItemName = ["항목1", "", "항목3"]

        // when & then
        XCTAssertFalse(sut.isValidForCreatePoll())
    }

    func test_isValidForCreatePoll_마감시간_30분미만이면_false() {
        // given
        sut.creatorNameText = "테스터"
        sut.titleText = "투표 제목"
        sut.pollItemName = ["항목1", "항목2", "항목3"]
        sut.selectedDate = Date().addingTimeInterval(10 * 60)

        // when & then
        XCTAssertFalse(sut.isValidForCreatePoll())
    }

    // MARK: - createPoll

    func test_createPoll_성공시_pollHashId와_goToPollDetail_설정됨() async {
        // given
        mockUseCase.createPollResult = .success("test-hash-id")
        sut.titleText = "투표 제목"
        sut.creatorNameText = "테스터"

        // when
        await sut.createPoll()

        // then
        XCTAssertEqual(sut.pollHashId, "test-hash-id")
        XCTAssertTrue(sut.goToPollDetail)
        XCTAssertFalse(sut.showErrorDialog)
        XCTAssertFalse(sut.isLoading)
    }

    func test_createPoll_성공후_contentReset_호출됨() async {
        // given
        mockUseCase.createPollResult = .success("hash")
        sut.titleText = "투표 제목"
        sut.creatorNameText = "테스터"

        // when
        await sut.createPoll()

        // then
        XCTAssertTrue(sut.titleText.isEmpty)
        XCTAssertTrue(sut.creatorNameText.isEmpty)
    }

    func test_createPoll_실패시_showErrorDialog_true() async {
        // given
        mockUseCase.createPollResult = .failure(.requestFailed("투표 생성 실패"))

        // when
        await sut.createPoll()

        // then
        XCTAssertTrue(sut.showErrorDialog)
        XCTAssertEqual(sut.errorMessage, "투표 생성 실패")
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - pollType & responseType

    func test_pollType_익명이면_ANONYMOUS() {
        sut.anonymousOption = .first
        XCTAssertEqual(sut.pollType, "ANONYMOUS")
    }

    func test_pollType_기명이면_NAMED() {
        sut.anonymousOption = .second
        XCTAssertEqual(sut.pollType, "NAMED")
    }

    func test_responseType_단일이면_SINGLE() {
        sut.countingOption = .first
        XCTAssertEqual(sut.responseType, "SINGLE")
    }

    func test_responseType_복수이면_MULTIPLE() {
        sut.countingOption = .second
        XCTAssertEqual(sut.responseType, "MULTIPLE")
    }

    // MARK: - updatePostImage

    func test_updatePostImage_이미지설정시_uiImage_업데이트됨() {
        // given
        let image = UIImage()

        // when
        sut.updatePostImage(index: 0, image: image)

        // then
        XCTAssertEqual(sut.uiImage[0], image)
        XCTAssertNotNil(sut.postImage[0])
    }

    func test_updatePostImage_nil전달시_해당인덱스_nil됨() {
        // given
        sut.updatePostImage(index: 1, image: UIImage())

        // when
        sut.updatePostImage(index: 1, image: nil)

        // then
        XCTAssertNil(sut.uiImage[1])
        XCTAssertNil(sut.postImage[1])
    }

    func test_showPHPicker_초기값은_6개_false() {
        XCTAssertEqual(sut.showPHPicker.count, 6)
        XCTAssertTrue(sut.showPHPicker.allSatisfy { !$0 })
    }

    // MARK: - contentReset

    func test_contentReset_호출시_모든필드_초기화됨() {
        // given
        sut.titleText = "제목"
        sut.creatorNameText = "이름"
        sut.pollItemName = ["항목1", "항목2", "항목3"]
        sut.anonymousOption = .second
        sut.countingOption = .second

        // when
        sut.contentReset()

        // then
        XCTAssertTrue(sut.titleText.isEmpty)
        XCTAssertTrue(sut.creatorNameText.isEmpty)
        XCTAssertEqual(sut.pollItemName, ["", "", ""])
        XCTAssertEqual(sut.anonymousOption, .first)
        XCTAssertEqual(sut.countingOption, .first)
    }
}
