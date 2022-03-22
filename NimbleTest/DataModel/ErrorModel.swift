//
//  ErrorModel.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

///Error Data Model for Network calls
struct ErrorModel: Codable {
    let source: Source
    let detail, code: String

    struct Source: Codable {
        let parameter: String
    }

}
