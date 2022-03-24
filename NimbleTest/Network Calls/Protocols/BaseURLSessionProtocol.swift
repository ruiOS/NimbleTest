//
//  BaseURLSessionProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation


/// baseDomainURL for all nimble apis
private let baseDomainURLString = "https://survey-api.nimblehq.co"

typealias ErrorHandleBlock = ((NetworkCallError)->Void)

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
    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: ErrorHandleBlock?, completionBlock: ((Data) -> Void)?)

}

extension BaseURLSessionProtocol{

    /// Creates string for given api using base domain
    /// - Parameter api: api for string creation
    /// - Returns: api after appending domain
    func generateURLString(fromapi api: String)->String{
        String(format: api, baseDomainURLString)
    }

    func performURLSession(forURLRequest urlRequest: URLRequest, errorBlock: ErrorHandleBlock?, completionBlock: ((Data) -> Void)?){
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
        let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            if let error = error {
                errorBlock?(.serverSideError(error.localizedDescription))
            }else if let data = data,
                     !data.isEmpty{
                completionBlock?(data)
            }else{
                errorBlock?(.noDataPresent)
            }
        }
        dataTask.resume()
    }

}
