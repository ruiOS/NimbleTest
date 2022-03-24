//
//  ErrorModel.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

enum ErrorCodeEnum:String, Codable{
    case invalidToken = "invalid_token"
    case invalidGrant = "invalid_grant"
}

///Error Data Model for Network calls
struct ErrorModel: Codable {
    let source: Source
    let detail: String
    let code: ErrorCodeEnum

    struct Source: Codable {
        let parameter: String
    }

}
