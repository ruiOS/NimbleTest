//
//  AuthTokenFetchManager.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import Foundation

protocol AuthTokenFetchManagerProtocol{
    var networkDataParser: NetworkDataParser { get set }
}

extension AuthTokenFetchManagerProtocol{
}

///Handles AuthToken fetch
struct AuthTokenFetchManager: AuthTokenFetchManagerProtocol {

    private let authTokenRefreshManager = AuthTokenRefreshManager()

    var networkDataParser: NetworkDataParser = NetworkDataParser()

    /// methods returns AuthToken
    /// - Parameter errorBlock: executes when an error occured in fetching
    /// - Returns: returns refresh token
    func getToken(errorBlock: @escaping ((TokenGenerationError) -> Void)) -> String {

        ///static instance of keyChainManager
        let keyChainManager = KeyChainManager.shared

        /// return no auth error if refresh token is invalid
        guard let refreshToken = keyChainManager.getString(forKey: .refreshToken),
              !refreshToken.isEmpty else {
            errorBlock(.noRefreshTokenAvailable)
            return ""
        }

        guard let accessToken = keyChainManager.getString(forKey: .accessToken),
              !accessToken.isEmpty,
              let tokenCreationTime = keyChainManager.getInteger(forKey: .tokenCreationTime),
              let expiryPeriod = keyChainManager.getInteger(forKey: .tokenExpiryPeriod) else{
            return fetchAuthTokenFromOnline(usingRefreshToken: refreshToken, errorBlock: errorBlock)
        }

        ///Expiration time of the token
        var expiryTime = Date(timeIntervalSince1970: TimeInterval(tokenCreationTime))
        expiryTime.addTimeInterval(TimeInterval(expiryPeriod))

        //return auth token if not expired
        if expiryTime > Date() {
            return accessToken
        }else{
            // fetch new token if expired
            return fetchAuthTokenFromOnline(usingRefreshToken: refreshToken, errorBlock: errorBlock)
        }
    }

    private func fetchAuthTokenFromOnline(usingRefreshToken refreshToken: String, errorBlock: @escaping ((TokenGenerationError) -> Void)) -> String{

        ///dispatch group to wait until token is fetched
        let group = DispatchGroup()
        ///access token
        var newAccessToken: String = ""

        // enter dispatch group
        group.enter()

        //fetch authToken from online
        DispatchQueue.global(qos: .background).sync {

            self.authTokenRefreshManager.refreshToken(usingRefreshToken: refreshToken){ error in
                errorBlock(.networkCallErrorOccured(error))
            } completionBlock: { authFetchResponse in
                networkDataParser.parse(Data: authFetchResponse) { responseData in
                    DispatchQueue.global(qos: .background).async(flags: .barrier){
                        KeyChainManager.shared.save(keyChainData: responseData.attributes)
                        newAccessToken = responseData.attributes.accessToken
                    }
                    DispatchQueue.main.async {
                        AppDelegate.shared?.window?.rootViewController = SurveyListViewController()
                    }
                    //leave group
                    group.leave()
                } errorBlock: { error in
                    errorBlock(.dataFetchErrorOccured(error))
                    //leave group
                    group.leave()
                }
            }
        }

        // wait until task is completed
        group.wait()
        //return authtoken and error
        return newAccessToken

    }

}
