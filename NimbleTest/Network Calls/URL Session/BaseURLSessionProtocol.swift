//
//  BaseURLSessionProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation

///Common HTTP MEthods
enum HTTPMethod:String {
    case get         =   "GET"
    case post        =   "POST"
    case put         =   "PUT"
    case delete      =   "DELETE"
}

///Grant type for api calls
enum GrantType:String{
    case password
    case refreshToken = "refresh_token"
}

/// baseDomainURL for all nimble apis
let baseDomainURLString = "https://survey-api.nimblehq.co"

typealias ErrorHandleBlock = ((AppErrors)->Void)

///Base URL Session Protocol consisting of common url session methods
protocol BaseURLSessionProtocol{

    ///sessionDelegateClass to handle sessionDelegate methods
    var sessionDelegate: URLSessionDelegate {get set}

    /// method used to append query items to url
    /// - Parameters:
    ///   - queryItems: query items to be appended to url
    ///   - urlString: string value of url to be created
    /// - Returns: create url using urlString and query Items
    func append(queryItems: [URLQueryItem], toURLString urlString: String) -> URL?
    
    /// perform's url session
    /// - Parameters:
    ///   - urlRequest: url request for which session need to be performed
    ///   - errorBlock: errorBlock if error is thrown
    ///   - completionBlock: completionBlock Passes Data to parse it
    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data) -> Void))

}

extension BaseURLSessionProtocol{

    func append(queryItems: [URLQueryItem], toURLString urlString: String) -> URL?{
        let url: String = String(format: urlString, baseDomainURLString)
        
        let tempQueryItems = queryItems + [ URLQueryItem(name: "client_id", value: "6GbE8dhoz519l2N_F99StqoOs6Tcmm1rXgda4q__rIw"),
                                   URLQueryItem(name: "client_secret", value: "_ayfIm7BeUAhx2W1OUqi20fwO3uNxfo1QstyKlFCgHw")]

        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = tempQueryItems
        return urlComps?.url
    }

}

extension BaseURLSessionProtocol{

    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data) -> Void)){
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
        let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            if let error = error {
                errorBlock(.serverSideError(error.localizedDescription))
            }else if let data = data,
                     !data.isEmpty{
                completionBlock(data)
            }else{
                errorBlock(.generalError)
            }
        }
        dataTask.resume()
    }

    func createURLRequest(withurl url: URL, withHTTPMethod httpMethod: HTTPMethod) -> URLRequest{
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = 15.0
        return urlRequest as URLRequest
    }
}
