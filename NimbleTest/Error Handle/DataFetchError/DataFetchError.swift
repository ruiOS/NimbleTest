//
//  DataFetchError.swift
//  NimbleTest
//
//  Created by rupesh-6878 on 25/03/22.
//

import Foundation

enum DataFetchError:Error, Equatable{
    case invalidAuthToken
    case dataNotFetched(String)
}
