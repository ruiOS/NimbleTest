//
//  LoginNetworkCallTestCases.swift
//  NimbleTestTests
//
//  Created by rupesh on 24/03/22.
//

import XCTest
@testable import NimbleTest

class LoginNetworkCallTestCases: XCTestCase {

    private let loginManager = LoginSessionManager()

    func testLoginFailureCases() {
        testFailedLoginCase(email: "", password: "")
        testFailedLoginCase(email: "fail", password: "fail")
    }

    private func testFailedLoginCase(email: String, password: String){
        let expectations = self.expectation(description: "FailedLogin")

        loginManager.getLoginDetails(emailID: email, password: password) { response in
            XCTAssertEqual(response.errors![0].code, .invalidGrant)
            XCTAssertNil(response.data)
            expectations.fulfill()
        } errorBlock: { _ in
        }

        waitForExpectations(timeout: 15)
    }

    func testSuccessFulLogin(){
        let expectations = self.expectation(description: "SuccessFullLogin")

        loginManager.getLoginDetails(emailID: "Dev@nimblehq.co", password: "12345678")  {response in
            XCTAssertNotNil(response.data)
            XCTAssertNil(response.errors)
            expectations.fulfill()
        } errorBlock: { _ in
        }
        waitForExpectations(timeout: 15)
    }

}
