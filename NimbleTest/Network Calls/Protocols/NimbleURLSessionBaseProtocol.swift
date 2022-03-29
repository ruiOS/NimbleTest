//
//  NimbleURLSessionBaseProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

///Base class for all Nimble specific data fetch url sessions
protocol NimbleURLSessionBaseProtocol: BaseURLSessionProtocol, CreateURLRequestProtocol, AuthValidationProtocol{
}

extension NimbleURLSessionBaseProtocol{

    /// Method used to fetch data for given api
    /// - Parameters:
    ///   - api: api to construct url
    ///   - successBlock: block called on completion
    ///   - errorBlock: block called if error is thrown
    func fetchDataForApi<T:Codable & ResponseDataProtocol>(api: String, queryParams: String? =  nil, usingAuthToken authToken: String, successBlock: @escaping ((T)-> Void), errorBlock: @escaping ErrorHandleBlock){

        let urlString = generateURLString(fromapi: api, queryParams: queryParams)

        guard let url = URL(string: urlString) else {
            errorBlock(.urlCantBeGenerated)
            return
        }

        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .get,withHeaders: [("Authorization", "Bearer \(authToken)")])

        self.performURLSession(forURLRequest: urlRequest as URLRequest, errorBlock: errorBlock) { data in
            do{
                let responseObject: T = try JSONDecoder().decode(T.self, from: data)
                successBlock(responseObject)
            } catch {
                errorBlock(.dataParseError(error.localizedDescription))
            }
        }
    }

}

