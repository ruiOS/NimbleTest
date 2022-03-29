//
//  SurveyDetailFetcher.swift
//  NimbleTest
//
//  Created by rupesh on 28/03/22.
//

import Foundation

struct SurveyDetailFetcher: NimbleURLSessionBaseProtocol, QueryItemsProtocol{

    var sessionDelegate: URLSessionDelegate = SSLPinningDelegate()

    /// method fetches login details for the uploaded parameters
    /// - Parameters:
    ///   - emailID: emailID of the user
    ///   - password: Password of the user
    ///   - successBlock: block called on comletion
    ///   - errorBlock: block called if error is thrown
    func getSurveyDetails(usingAuthToken authToken: String, forSurveyID surveyID: String, successBlock: @escaping ((SurveyDetailDataModel)-> Void), errorBlock: @escaping ErrorHandleBlock){
        fetchDataForApi(api: "%@/api/v1/surveys/%@", queryParams: surveyID, usingAuthToken: authToken, successBlock: successBlock, errorBlock: errorBlock)
    }

}
