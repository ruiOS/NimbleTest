//
//  LocalisedString.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import Foundation

/// Methos takes a key value of localised string and a comment and produce a localised string
@propertyWrapper struct LocalisedString{
    let key: String
    let comment: String

    var wrappedValue: String{
        get {
            let localisedString = NSLocalizedString(key, comment: comment)
            if key == localisedString{
                return comment
            }else{
                return localisedString
            }
        }
    }
}
