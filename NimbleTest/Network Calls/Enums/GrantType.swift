//
//  GrantType.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

///Grant type for api calls
enum GrantType:String{
    case password
    case refreshToken = "refresh_token"
}
