//
//  LoginSessionManager.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import Foundation

///Network Manager to handle Login
class LoginSessionManager: NSObject, BaseURLSessionProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method fetches login/keychain details for the uploaded parameters
    /// - Parameters:
    ///   - emailID: emailID of the user
    ///   - password: Password of the user
    ///   - successBlock: block called on comletion
    ///   - errorBlock: block called if error is thrown
    func getLoginDetails(emailID: String, password: String, successBlock: @escaping ((KeyChainJsonClass)-> Void), errorBlock: @escaping ErrorHandleBlock){

        let queryItems = [
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "client_id", value: "6GbE8dhoz519l2N_F99StqoOs6Tcmm1rXgda4q__rIw"),
            URLQueryItem(name: "client_secret", value: "_ayfIm7BeUAhx2W1OUqi20fwO3uNxfo1QstyKlFCgHw"),
            URLQueryItem(name: "email", value: emailID),
            URLQueryItem(name: "password", value: password)]

        guard let url = append(queryItems: queryItems, toURLString: "%@/api/v1/oauth/token") else {
            errorBlock(.urlCantBeGenerated)
            return
        }

        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.timeoutInterval = 15.0

        performURLSession(forURLRequest: urlRequest as URLRequest, errorBlock: errorBlock) { data in
            do{
                let responseObject: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                if let responseData = responseObject.data {
                    successBlock(responseData.attributes)
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
