//
//  NetworkCallErrorProtcol.swift
//  NimbleTest
//
//  Created by rupesh-6878 on 24/03/22.
//

import Foundation

protocol NetworkCallErrorProtcol{}

extension NetworkCallErrorProtcol where Self: ErrorHandleRequiredProtcols{

    func handle(networkCallError: NetworkCallError){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dismissHud()
            switch networkCallError {
            case .serverSideError(let message):
                weakSelf.displayAlert(withTitle: nil, withMessage: message)
            case .dataParseError(let message):
                weakSelf.displayAlert(withTitle: AppStrings.error_dataParseError, withMessage: message)
            case .urlCantBeGenerated:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_urlCantBeGenerated)
            case .noNetworkConnection:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_noNetworkConnection)
            case .requestTimedOut:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_requestTimedOut)
            case .noDataPresent:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_noDataReturned)
            }
        }
    }
}
