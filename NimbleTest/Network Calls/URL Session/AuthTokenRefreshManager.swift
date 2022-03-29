//
//  AuthTokenRefreshManager.swift
//  NimbleTest
//
//  Created by rupesh on 25/03/22.
//

import Foundation

struct AuthTokenRefreshManager: BaseURLSessionProtocol, QueryItemsProtocol, CreateURLRequestProtocol, FetchAuthTokenProtocol {

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method fetch refresh token from online
    /// - Parameters:
    ///   - errorBlock: error Block executes if error is thrown
    ///   - completionBlock: completion block executes on completion
    func refreshToken(usingRefreshToken refreshToken: String, errorBlock: ErrorHandleBlock?, completionBlock: @escaping ((LoginResponse)->Void)){
        let queryItems = [
            URLQueryItem(name: "grant_type", value: GrantType.refreshToken.rawValue),
            URLQueryItem(name: "refresh_token", value: refreshToken)]

        guard let url = append(queryItems: queryItems, toURLString: "%@/api/v1/oauth/token") else {
            errorBlock?(.urlCantBeGenerated)
            return
        }
        fetchAuthToken(forURL: url, successBlock: completionBlock, errorBlock: errorBlock)
    }

}
