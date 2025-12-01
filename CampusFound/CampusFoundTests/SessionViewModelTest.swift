//
//  SessionViewModelTest.swift
//  CampusFound
//
//  Created by Adrian Ninanya on 11/30/25.
//

import XCTest
@testable import CampusFound

final class SessionViewModelTest: XCTestCase {

    var sut: SessionViewModel!

    override func setUp() {
        super.setUp()
        sut = SessionViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testLoginSucceedsWithEduEmail() {
        sut.email = "student@suu.edu"
        sut.login()

        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNil(sut.errorMessage)
    }

    func testLoginFailsWithNonEduEmail() {
        sut.email = "test@gmail.com"
        sut.login()

        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.errorMessage, "Please use a valid university .edu email.")
    }

    func testEmailIsTrimmedAndLowercased() {
        sut.email = "   STUDENT@SUU.EDU   "
        sut.login()

        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNil(sut.errorMessage)
    }

    func testLogoutResetsAllFields() {
        sut.email = "student@suu.edu"
        sut.login()

        sut.logout()

        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.email, "")
        XCTAssertNil(sut.errorMessage)
    }
}
