//
//  NimbleTestUITests.swift
//  NimbleTestUITests
//
//  Created by rupesh on 20/03/22.
//

import XCTest
@testable import NimbleTest

class NimbleTestUITests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func setUp() {
        setupSnapshot(app)  
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Login TextCases

    func testLoginTestCases(){
        checkLoginSetUp()
        checkEmptyLogin()
        //checkInvalidLogin()
        checkValidLogin()
    }

    private func checkLoginSetUp(){
        app.launch()
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
        snapshot("testLogin")
    }

    ///method tests empty Login
    private func checkEmptyLogin(){
        app.launch()
        app.textFields[AppStrings.login_email].tap()
        app.secureTextFields[AppStrings.login_password].tap()
        app.staticTexts[AppStrings.login].tap()
        let alert = app.alerts[AppStrings.error_dataInadequate]
        XCTAssertFalse(alert.exists)
    }

    func testCheckInvalidLogin(){
        app.launch()
        let emailTextField = app.textFields[AppStrings.login_email]
        emailTextField.typeText("Invalid Email")
        let passwordSecureTextField = app.secureTextFields[AppStrings.login_password]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("Invalid Password")
        let loginButton = app.buttons[AppStrings.login]
        loginButton.tap()

        let hud = app.otherElements["SVProgressHUD"]
        XCTAssert(hud.exists)

       let alert = XCUIApplication().alerts.scrollViews.otherElements.buttons["Ok"]
//        let alert = app.alerts["Authentication Error"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: alert)
        waitForExpectations(timeout: 15)
        
//        elementsQuery.buttons["Ok"].tap()

        print(app.alerts.keys.description)
                
        XCTAssert(alert.exists)
//        let okButton = alert.scrollViews.otherElements.buttons["Ok"]
//        XCTAssert(okButton.exists)

//        okButton.tap()

//        XCTAssertFalse(alert.exists)
//        XCTAssertFalse(okButton.exists)
    }

    func checkValidLogin(){
        app.launch()
        let emailTextField = app.textFields[AppStrings.login_email]
        emailTextField.typeText("dev@nimblehq.co")
        let passwordSecureTextField = app.secureTextFields[AppStrings.login_password]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("12345678")
        let loginButton = app.buttons[AppStrings.login]
        loginButton.tap()

        let hud = app.otherElements["SVProgressHUD"]
        XCTAssert(hud.exists)


        expectation(for: NSPredicate(format: "exists != 1"), evaluatedWith: emailTextField)
        waitForExpectations(timeout: 15)

        XCTAssertFalse(emailTextField.exists)
    }

    func testLauchScreen(){
        
        let todayStaticText = app.staticTexts["Today"]
        XCTAssert(todayStaticText.exists)

        XCTAssert(app.buttons["Arrow"].exists)
        
        XCTAssert(app.staticTexts["We'd love ot hear from you!"].exists)
        
        XCTAssertFalse(app.staticTexts["Scarlett Bangkok"].exists)
        
        app.staticTexts["Wednesday March, 23"].tap()

    }

}
