//
//  AppErrors.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation

///Errors Defined across the app
enum AppErrors: Error, Equatable{
    case serverSideError(String)
    case authenticationError(String)
    case dataParseError(String)
    case generalError
    case urlCantBeGenerated
    case noNetworkConnection
    case requestTimedOut
    case noDataFound
    case noAuthToken
    case invalidAuthToken
}
