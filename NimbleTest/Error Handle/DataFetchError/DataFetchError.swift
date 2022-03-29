//
//  DataFetchError.swift
//  NimbleTest
//
//  Created by rupesh on 25/03/22.
//

import Foundation

enum DataFetchError:Error, Equatable{
    case invalidAuthToken
    case dataNotFetched(String)
}
