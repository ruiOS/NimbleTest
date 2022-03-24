//
//  AuthValidationProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

///consistis of methods to validate authtoken
protocol AuthValidationProtocol{
    /// returns if authtoken is invalid
    /// - Parameter errors: errorModels in the error json received
    /// - Returns: if authtoken is valid
    func checkAuthValidation(forErrors errors: [ErrorModel]?) -> Bool
}

extension AuthValidationProtocol{

    func checkAuthValidation(forErrors errors: [ErrorModel]?) -> Bool{
        guard let errors = errors else {
            return false
        }
        return  errors.contains(where: {$0.code == .invalidToken})
    }

}
