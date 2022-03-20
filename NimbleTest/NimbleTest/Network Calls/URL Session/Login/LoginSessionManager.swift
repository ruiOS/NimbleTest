//
//  LoginSessionManager.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import Foundation

class LoginSessionManager: NSObject, BaseURLSessionProtocol, URLSessionDelegate{

    func getLoginDetails(emailID: String, password: String, successBlock: @escaping SuccessBlock, errorBlock: @escaping ErrorHandleBlock){

        let queryItems = [
            URLQueryItem(name: "grant_type", value: "password"),
            URLQueryItem(name: "client_id", value: "6GbE8dhoz519l2N_F99StqoOs6Tcmm1rXgda4q__rIw"),
            URLQueryItem(name: "client_secret", value: "_ayfIm7BeUAhx2W1OUqi20fwO3uNxfo1QstyKlFCgHw"),
            URLQueryItem(name: "email", value: emailID),
            URLQueryItem(name: "password", value: password)]

        guard let url = append(queryItems: queryItems, toURL: "https://survey-api.nimblehq.co/api/v1/oauth/token") else {
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

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           challenge.protectionSpace.host == "survey-api.nimblehq.co" {

            if let pem = Bundle.main.url(forResource:"sni.cloudflaressl.com", withExtension: "cer"),
               let data = NSData(contentsOf: pem),
               let cert = SecCertificateCreateWithData(nil, data) {
                let certs = [cert]
                SecTrustSetAnchorCertificates(serverTrust, certs as CFArray)
                var result=SecTrustResultType.invalid
                if SecTrustEvaluate(serverTrust,&result)==errSecSuccess {
                    if result==SecTrustResultType.proceed || result==SecTrustResultType.unspecified {
                        let proposedCredential = URLCredential(trust: serverTrust)
                        completionHandler(.useCredential,proposedCredential)
                        return
                    }
                }
                
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }

}
