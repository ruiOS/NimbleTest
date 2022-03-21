//
//  NimbleTestTests.swift
//  NimbleTestTests
//
//  Created by rupesh on 20/03/22.
//

import XCTest
@testable import NimbleTest

class NimbleTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testKeyChainManager(){
        let refreshToken = "refreshToken"
        let accessToken = "accessToken"
        let expiresIn = 1000
        let createdAt = 7000
        let keyChainData = KeyChainJsonClass(accessToken: accessToken, tokenType: "", expiresIn: expiresIn, refreshToken: refreshToken, createdAt: createdAt)

        XCTAssertEqual(keyChainData.accessToken, accessToken)
        XCTAssertEqual(keyChainData.expiresIn, expiresIn)
        XCTAssertEqual(keyChainData.createdAt, createdAt)
        XCTAssertEqual(keyChainData.refreshToken, refreshToken)

        testSaveKeyChainData(keyChainData: keyChainData)
        mockTestKeyChainUpdate()
        mockTestKeyChainDelete()
        mockTestKeyChainBulkDelete()
    }

    func testSaveKeyChainData(keyChainData: KeyChainJsonClass){
        let keychainManager = KeyChainManager.shared

        keychainManager.save(keyChainData: keyChainData)

        XCTAssertEqual(keyChainData.accessToken, keychainManager.getString(forKey: .accessToken))
        XCTAssertEqual(keyChainData.expiresIn, keychainManager.getInteger(forKey: .tokenExpiryPeriod))
        XCTAssertEqual(keyChainData.createdAt, keychainManager.getInteger(forKey: .tokenCreationTime))
        XCTAssertEqual(keyChainData.refreshToken, keychainManager.getString(forKey: .refreshToken))
    }

    func mockTestKeyChainUpdate(){
        let keychainManager = KeyChainManager.shared

        let expiresIn = 1001
        let createdAt = 7001
        let refreshToken = "refreshToken2"
        let accessToken = "accessToken2"

        keychainManager.save(integer: expiresIn, key: .tokenExpiryPeriod)
        keychainManager.save(integer: createdAt, key: .tokenCreationTime)
        keychainManager.save(string: refreshToken, forKey: .refreshToken)
        keychainManager.save(string: accessToken, forKey: .accessToken)

        XCTAssertEqual(accessToken, keychainManager.getString(forKey: .accessToken))
        XCTAssertEqual(expiresIn, keychainManager.getInteger(forKey: .tokenExpiryPeriod))
        XCTAssertEqual(createdAt, keychainManager.getInteger(forKey: .tokenCreationTime))
        XCTAssertEqual(refreshToken, keychainManager.getString(forKey: .refreshToken))
    }

    func mockTestKeyChainDelete(){
        let keychainManager = KeyChainManager.shared

        keychainManager.removeObject(forKey: .tokenExpiryPeriod)
        keychainManager.removeObject(forKey: .tokenCreationTime)
        keychainManager.removeObject(forKey: .refreshToken)
        keychainManager.removeObject(forKey: .accessToken)

        XCTAssertNil(keychainManager.getString(forKey: .accessToken))
        XCTAssertNil(keychainManager.getString(forKey: .refreshToken))
        XCTAssertNil(keychainManager.getInteger(forKey: .tokenExpiryPeriod))
        XCTAssertNil(keychainManager.getInteger(forKey: .tokenCreationTime))

    }

    func mockTestKeyChainBulkDelete(){
        let keychainManager = KeyChainManager.shared

        keychainManager.deleteKeyChainData()

        XCTAssertNil(keychainManager.getString(forKey: .accessToken))
        XCTAssertNil(keychainManager.getString(forKey: .refreshToken))
        XCTAssertNil(keychainManager.getInteger(forKey: .tokenExpiryPeriod))
        XCTAssertNil(keychainManager.getInteger(forKey: .tokenCreationTime))

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
