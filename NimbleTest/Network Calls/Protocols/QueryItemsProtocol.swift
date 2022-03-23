//
//  QueryItemsProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

///consists of methods to append query items to url
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
