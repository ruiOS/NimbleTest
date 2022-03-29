//
//  ResponseDataProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

protocol ResponseDataProtocol{

    associatedtype CodableType: Codable

    var errors: [ErrorModel]? {get set}
    var data: CodableType? {get set}
}

