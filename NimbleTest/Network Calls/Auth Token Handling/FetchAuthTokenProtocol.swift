//
//  FetchAuthTokenProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import Foundation
///protocol handles fetching authToken
protocol FetchAuthTokenProtocol{

}

extension FetchAuthTokenProtocol where Self: BaseURLSessionProtocol & CreateURLRequestProtocol{

    /// Methods fetches new authToken
    /// - Parameters:
    ///   - url: url to fetch data
    ///   - successBlock: completion block if call is successFul
    ///   - errorBlock: block exectutes when error is thrown
    func fetchAuthToken(forURL url: URL, successBlock: @escaping ((LoginResponse)-> Void), errorBlock: ErrorHandleBlock?){
        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .post)
        self.performURLSession(forURLRequest: urlRequest as URLRequest, errorBlock: errorBlock) { data in
            do{
                let responseObject: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                successBlock(responseObject)
            } catch {
                errorBlock?(.dataParseError(error.localizedDescription))
                return
            }
        }
    }

}
