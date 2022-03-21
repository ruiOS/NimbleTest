//
//  NimbleTestUITests.swift
//  NimbleTestUITests
//
//  Created by rupesh on 20/03/22.
//

import XCTest

class NimbleTestUITests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func setUp() {
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginSetUp(){
        let nimbleLogo = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let emailTextField = app.textFields[AppStrings.login_email]
        let passwordSecureTextField = app.secureTextFields[AppStrings.login_password]
        let forgotPasswordButton = app.staticTexts[AppStrings.login_forgotPassword]
        let loginButton = app.buttons[AppStrings.login]

        XCTAssert(nimbleLogo.exists)
        XCTAssert(emailTextField.exists)
        XCTAssert(passwordSecureTextField.exists)
        XCTAssert(forgotPasswordButton.exists)
        XCTAssert(loginButton.exists)
    }

    ///method tests empty Login
    func testEmptyLogin(){
        app.textFields[AppStrings.login_email].tap()
        app.secureTextFields[AppStrings.login_password].tap()
        app.staticTexts[AppStrings.login].tap()
        let alert = app.alerts[AppStrings.error_dataInadequate]
        XCTAssertFalse(alert.exists)
    }

}
