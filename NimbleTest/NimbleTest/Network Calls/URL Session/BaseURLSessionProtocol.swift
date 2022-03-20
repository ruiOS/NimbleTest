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

typealias ErrorHandleBlock = ((AppErrors)->Void)
typealias SuccessBlock = (()->Void)

///Base URL Session Protocol consisting of common url session methods
protocol BaseURLSessionProtocol{
    
    /// method used to append query items to url
    /// - Parameters:
    ///   - queryItems: query items to be appended to url
    ///   - url: string value of url to be created
    /// - Returns: create url using urlString and query Items
    func append(queryItems: [URLQueryItem], toURL url: String) -> URL?
    
    /// perform's url session
    /// - Parameters:
    ///   - urlRequest: url request for which session need to be performed
    ///   - errorBlock: errorBlock if error is thrown
    ///   - completionBlock: completionBlock Passes Data to parse it
    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data) -> Void))
}

extension BaseURLSessionProtocol{

    func append(queryItems: [URLQueryItem], toURL url: String) -> URL?{
        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = queryItems
        return urlComps?.url
    }

}

extension BaseURLSessionProtocol where Self: URLSessionDelegate{

    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data) -> Void)){
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
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
