//
//  UserData.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

struct UserData: Codable, ErrorResponseProtocol {
    let data: User?
    var errors: [ErrorModel]?
}

// MARK: - DataClass
struct User: Codable {
    let id, type: String
    let attributes: Attributes

    struct Attributes: Codable {
        let email, name: String
        let avatarURL: String

        enum CodingKeys: String, CodingKey {
            case email, name
            case avatarURL = "avatar_url"
        }
    }
}
