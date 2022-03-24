//
//  NetworkCallError.swift
//  NimbleTest
//
//  Created by rupesh-6878 on 25/03/22.
//

import Foundation

enum NetworkCallError:Error, Equatable{
    case serverSideError(String)
    case noDataPresent
    case dataParseError(String)
    case urlCantBeGenerated
    case noNetworkConnection
    case requestTimedOut
}
