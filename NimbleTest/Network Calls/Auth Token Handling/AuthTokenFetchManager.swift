//
//  AuthTokenFetchManager.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import Foundation

///Handles AuthToken fetch
class AuthTokenFetchManager: BaseURLSessionProtocol, FetchAuthTokenProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()
    
    /// methods returns AuthToken
    /// - Parameter errorBlock: executes when an error occured in fetching
    /// - Returns: returns refresh token and AuthToken error if present
    func getToken(errorBlock: @escaping ErrorHandleBlock) -> (String, AppErrors?) {

        ///static instance of keyChainManager
        let keyChainManager = KeyChainManager.shared

        /// return no auth error if refresh token is invalid
        guard let accessToken = keyChainManager.getString(forKey: .accessToken),
              !accessToken.isEmpty,
              let tokenCreationTime = keyChainManager.getInteger(forKey: .tokenCreationTime),
              let expiryPeriod = keyChainManager.getInteger(forKey: .tokenExpiryPeriod) else {
            return ("",.noAuthToken)
        }

        ///Expiration time of the token
        var expiryTime = Date(timeIntervalSince1970: TimeInterval(tokenCreationTime))
        expiryTime.addTimeInterval(TimeInterval(expiryPeriod))

        //return auth token if not expired
        if expiryTime > Date() {
            return (accessToken,nil)
        }else{
            // fetch new token if expired

            ///dispatch group to wait until token is fetched
            let group = DispatchGroup()
            ///access token
            var newAccessToken: String = ""
            /// error if found
            var error: AppErrors?
            // enter dispatch group
            group.enter()

            //fetch authToken from online
            DispatchQueue.global(qos: .background).sync { [weak self] in
                self?.refreshToken(errorBlock: errorBlock, completionBlock: {
                    //token is present
                    if let token = KeyChainManager.shared.getString(forKey: .refreshToken), !token.isEmpty{
                        (newAccessToken,error) = (token,nil)
                    }else{
                        //token is absent
                        (newAccessToken,error) = ("",.noAuthToken)
                    }
                    //leave group
                    group.leave()
                })
            }

            // wait until task is completed
            group.wait()
            //return authtoken and error
            return (newAccessToken,error)
        }
    }
    
    /// method fetch refresh token from online
    /// - Parameters:
    ///   - errorBlock: error Block executes if error is thrown
    ///   - completionBlock: completion block executes on completion
    private func refreshToken(errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping (()->Void)){
        let queryItems = [
            URLQueryItem(name: "grant_type", value: GrantType.refreshToken.rawValue),
            URLQueryItem(name: "refresh_token", value: KeyChainManager.shared.getString(forKey: .refreshToken))]

        guard let url = append(queryItems: queryItems, toURLString: "%@/api/v1/oauth/token") else {
            errorBlock(.urlCantBeGenerated)
            return
        }

        fetchAuthToken(forURL: url, successBlock: completionBlock, errorBlock: errorBlock)
    }
}
