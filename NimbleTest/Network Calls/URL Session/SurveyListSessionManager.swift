//
//  SurveyListSessionManager.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

///Network Manager to handle Login
class SurveyListSessionManager: NSObject, BaseURLSessionProtocol, FetchAuthTokenProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method fetches login/keychain details for the uploaded parameters
    /// - Parameters:
    ///   - emailID: emailID of the user
    ///   - password: Password of the user
    ///   - successBlock: block called on comletion
    ///   - errorBlock: block called if error is thrown
    func getSurveyDetails(successBlock: @escaping (()-> Void), errorBlock: @escaping ErrorHandleBlock){

        let urlString = generateURLString(fromapi: "%@/api/v1/surveys")
        guard let url = URL(string: urlString) else {
            errorBlock(.urlCantBeGenerated)
            return
        }

        let authToken = AuthTokenFetchManager().getToken(errorBlock: errorBlock)
        guard !authToken.isEmpty
               else {
            return
        }

        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .get,withHeaders: [("Authorization", "Bearer \(authToken)")])
        fetchAuthToken(forURL: url, successBlock: successBlock, errorBlock: errorBlock)

        self.performURLSession(forURLRequest: urlRequest as URLRequest, errorBlock: errorBlock) { data in
            do{
                let responseObject: SurveyList = try JSONDecoder().decode(SurveyList.self, from: data)
                if let responseData = responseObject.data {
                    successBlock()
                    return
                }else if let errors = responseObject.errors,
                         !errors.isEmpty{
                    errorBlock(.authenticationError(errors[0].detail))
                    return
                }
                errorBlock(.generalError)
            }
            catch{
                errorBlock(.dataParseError(error.localizedDescription))
                return
            }
        }

    }

}
