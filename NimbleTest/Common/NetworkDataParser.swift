//
//  NetworkDataParser.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

struct NetworkDataParser: AuthValidationProtocol{

    func parse<T:ResponseDataProtocol>(Data responseData: T, completionBlock: ((T.CodableType)-> Void), errorBlock: ((DataFetchError)-> Void)){
        if let errors = responseData.errors{
            if !errors.isEmpty{
                if self.checkAuthValidation(forErrors: errors){
                    errorBlock(.invalidAuthToken)
                    return
                }
                errorBlock(.dataNotFetched(errors[0].detail))
            }
        }else if let data = responseData.data{
            completionBlock(data)
        }
    }

}
