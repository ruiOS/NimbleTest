//
//  TokenGenerationError.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation

///Errors Defined across the app
enum TokenGenerationError: Error, Equatable{
    case noRefreshTokenAvailable
    case refreshTokenExpired
    case networkCallErrorOccured(NetworkCallError)
    case dataFetchErrorOccured(DataFetchError)
}
