//
//  CreateURLRequestProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

///Consists of methods to create url session
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
