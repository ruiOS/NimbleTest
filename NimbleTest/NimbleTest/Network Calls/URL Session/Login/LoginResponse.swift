//
//  LoginResponse.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import Foundation

// MARK: - LoginResponse
///Data Repsonse of Login urlSession
struct LoginResponse: Codable {

    ///Data Class consisting of Data
    let data: DataClass?

    ///Errors if thrown
    let errors: [Error]?

    struct Error: Codable {
        let source: Source
        let detail, code: String

        struct Source: Codable {
            let parameter: String
        }

    }

    struct DataClass: Codable {
        let id, type: String
        let attributes: KeyChainJsonClass
    }

}

struct KeyChainJsonClass: Codable {
    let accessToken, tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}
