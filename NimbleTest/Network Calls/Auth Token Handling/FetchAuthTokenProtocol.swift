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
    
    /// Methods fetches new authToken and replace the value in keychain
    /// - Parameters:
    ///   - url: url to fetch data
    ///   - successBlock: completion block if call is successFul
    ///   - errorBlock: block exectutes when error is thrown
    func fetchAuthToken(forURL url: URL, successBlock: @escaping (()-> Void), errorBlock: @escaping ErrorHandleBlock){
        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .post)
        self.performURLSession(forURLRequest: urlRequest as URLRequest, errorBlock: errorBlock) { data in
            do{
                let responseObject: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                if let responseData = responseObject.data {
                    KeyChainManager.shared.save(keyChainData: responseData.attributes)
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
