//
//  SurveyListSessionManager.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

///Network Manager to handle Login
class SurveyListSessionManager: NimbleURLSessionBaseClass, QueryItemsProtocol, FetchAuthTokenProtocol{

    /// method fetches login/keychain details for the uploaded parameters
    /// - Parameters:
    ///   - emailID: emailID of the user
    ///   - password: Password of the user
    ///   - successBlock: block called on comletion
    ///   - errorBlock: block called if error is thrown
    func getSurveyDetails(successBlock: @escaping ((SurveyList)-> Void), errorBlock: @escaping ErrorHandleBlock){
        fetchDataForApi(api: "%@/api/v1/surveys", successBlock: successBlock, errorBlock: errorBlock)
    }

}
