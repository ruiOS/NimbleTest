//
//  LoginSessionManager.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import Foundation

///Network Manager to handle Login
struct LoginSessionManager: BaseURLSessionProtocol, QueryItemsProtocol, CreateURLRequestProtocol, FetchAuthTokenProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method fetches login/details for the uploaded parameters
    /// - Parameters:
    ///   - emailID: emailID of the user
    ///   - password: Password of the user
    ///   - successBlock: block called on completion
    ///   - errorBlock: block called if error is thrown
    func getLoginDetails(emailID: String, password: String, successBlock: @escaping ((LoginResponse)-> Void), errorBlock: @escaping ErrorHandleBlock){

        let queryItems = [
            URLQueryItem(name: "grant_type", value: GrantType.password.rawValue),
            URLQueryItem(name: "email", value: emailID),
            URLQueryItem(name: "password", value: password)]

        guard let url = append(queryItems: queryItems, toURLString: "%@/api/v1/oauth/token") else {
            errorBlock(.urlCantBeGenerated)
            return
        }
        fetchAuthToken(forURL: url, successBlock: successBlock, errorBlock: errorBlock)
    }

}
