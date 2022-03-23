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

    func generateURLString(fromapi: String)->String

    /// perform's url session
    /// - Parameters:
    ///   - urlRequest: url request for which session need to be performed
    ///   - errorBlock: errorBlock if error is thrown
    ///   - completionBlock: completionBlock Passes Data to parse it
    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data) -> Void))

}

extension BaseURLSessionProtocol{
    
    /// Creates string for given api using base domain
    /// - Parameter api: api for string creation
    /// - Returns: api after appending domain
    func generateURLString(fromapi api: String)->String{
        String(format: api, baseDomainURLString)
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

}

protocol QueryItemsProtocol{
    /// method used to append query items to url
    /// - Parameters:
    ///   - queryItems: query items to be appended to url
    ///   - urlString: string value of url to be created
    /// - Returns: create url using urlString and query Items
    func append(queryItems: [URLQueryItem], toURLString urlString: String) -> URL?
}

extension QueryItemsProtocol where Self: BaseURLSessionProtocol{

    func append(queryItems: [URLQueryItem], toURLString urlString: String) -> URL?{
        let url: String = generateURLString(fromapi: urlString)
        
        let tempQueryItems = queryItems + [ URLQueryItem(name: "client_id", value: "6GbE8dhoz519l2N_F99StqoOs6Tcmm1rXgda4q__rIw"),
                                   URLQueryItem(name: "client_secret", value: "_ayfIm7BeUAhx2W1OUqi20fwO3uNxfo1QstyKlFCgHw")]

        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = tempQueryItems
        return urlComps?.url
    }

}

protocol CreateURLRequestProtocol{
    /// creates url request
    /// - Parameters:
    ///   - url: url for which request need to be created
    ///   - httpMethod: http method type of the request
    ///   - headers: headers to be added for url request
    /// - Returns: url request with specified parameters
    func createURLRequest(withurl url: URL, withHTTPMethod httpMethod: HTTPMethod, withHeaders headers:[(String,String)]) -> URLRequest
}

extension CreateURLRequestProtocol{

    func createURLRequest(withurl url: URL, withHTTPMethod httpMethod: HTTPMethod, withHeaders headers:[(String,String)] = []) -> URLRequest{
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = 15.0
        for (key, value) in headers{
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest as URLRequest
    }
}
