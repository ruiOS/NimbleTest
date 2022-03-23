//
//  NimbleURLSessionBaseClass.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

///Base class for all Nimble specific data fetch url sessions
class NimbleURLSessionBaseClass: NSObject, BaseURLSessionProtocol, CreateURLRequestProtocol, AuthValidationProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()
    
    /// Method used to fetch data for given api
    /// - Parameters:
    ///   - api: api to construct url
    ///   - successBlock: block called on completion
    ///   - errorBlock: block called if error is thrown
    func fetchDataForApi<T:Codable & ErrorResponseProtocol>(api: String, successBlock: @escaping ((T)-> Void), errorBlock: @escaping ErrorHandleBlock){
        let urlString = generateURLString(fromapi: api)

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

        self.performURLSession(forURLRequest: urlRequest as URLRequest, errorBlock: errorBlock) { [weak self] data in
            do{
                let responseObject: T = try JSONDecoder().decode(T.self, from: data)
                if let errors = responseObject.errors,
                         !errors.isEmpty{
                    if let weakSelf = self, weakSelf.checkAuthValidation(forErrors: errors){
                        errorBlock(.invalidAuthToken)
                    }else{
                        errorBlock(.serverSideError(errors[0].detail))
                    }
                    return
                }else {
                    successBlock(responseObject)
                    return
                }
            }
            catch{
                errorBlock(.dataParseError(error.localizedDescription))
                return
            }
        }
    }

}

