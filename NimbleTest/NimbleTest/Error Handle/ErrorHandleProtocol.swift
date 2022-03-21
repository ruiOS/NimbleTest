//
//  ErrorHandleProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import UIKit

/// Handles all error in the app
protocol ErrorHandleProtocol{
    /// Method handles error in app
    /// - Parameter error: error to be handled
    func handle(error: AppErrors)
}

extension ErrorHandleProtocol where Self: UIViewController & LoaderProtocol{

    func handle(error: AppErrors){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dismissHud()

            switch error {
            case .serverSideError(let message):
                weakSelf.displayAlert(withTitle: nil, withMessage: message)
            case .authenticationError(let message):
                weakSelf.displayAlert(withTitle: AppStrings.error_authenticationError, withMessage: message)
            case .dataParseError(let message):
                weakSelf.displayAlert(withTitle: AppStrings.error_dataParseError, withMessage: message)
            case .generalError:
                weakSelf.displayAlert(withTitle: AppStrings.error_anErrorOccured, withMessage: AppStrings.error_pleaseTryAgain)
            case .urlCantBeGenerated:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_urlCantBeGenerated)
            case .noNetworkConnection:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_noNetworkConnection)
            case .requestTimedOut:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_requestTimedOut)
            case .noDataFound:
                weakSelf.displayAlert(withTitle: AppStrings.error_dataInadequate, withMessage: AppStrings.error_enterRequiredData)
            }
        }
    }
    
    /// Display alert using the given parameters
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    func displayAlert(withTitle title: String?,withMessage message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.common_ok, style: .default))
        self.present(alert, animated: true)
    }
}
