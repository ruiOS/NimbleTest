//
//  LogoutSessionManager.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

struct LogoutSessionManager: BaseURLSessionProtocol, CreateURLRequestProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method logs out user
    /// - Parameter token: auth token of user
    func logOutUser(forToken token: String?){
        let urlString = generateURLString(fromapi: "%@/api/v1/oauth/revoke")
        guard let url = URL(string: urlString),
              let authToken = token,
              !authToken.isEmpty else {
            return
        }

        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .get,withHeaders: [("Authorization", "Bearer \(authToken)")])
        performURLSession(forURLRequest: urlRequest, errorBlock: nil, completionBlock: nil)
    }
    
}
