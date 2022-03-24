//
//  UserDetailsFetcher.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

struct UserDetailsFetcher: NimbleURLSessionBaseProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method used to fetch details of user
    /// - Parameters:
    ///   - errorBlock: error block executes when error is thrown
    ///   - successBlock: completion block on fetching data
    func fetchUserDetails(usingAuthToken authToken: String, successBlock: @escaping ((UserData)-> Void), errorBlock: @escaping ErrorHandleBlock){
        fetchDataForApi(api: "%@/api/v1/me", usingAuthToken: authToken, successBlock: successBlock, errorBlock: errorBlock)
    }

}
