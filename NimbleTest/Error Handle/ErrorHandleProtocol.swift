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
    func handle(error: AppErrors, withErrorCompletion completion: (()->Void)?)
}

extension ErrorHandleProtocol where Self: UIViewController & LoaderProtocol{

    func handle(error: AppErrors, withErrorCompletion completion: (()->Void)? = nil){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dismissHud()

            switch error {
            case .serverSideError(let message):
                weakSelf.displayAlert(withTitle: nil, withMessage: message, completion: completion)
            case .authenticationError(let message):
                weakSelf.displayAlert(withTitle: AppStrings.error_authenticationError, withMessage: message, completion: completion)
            case .dataParseError(let message):
                weakSelf.displayAlert(withTitle: AppStrings.error_dataParseError, withMessage: message, completion: completion)
            case .generalError:
                weakSelf.displayAlert(withTitle: AppStrings.error_anErrorOccured, withMessage: AppStrings.error_pleaseTryAgain, completion: completion)
            case .urlCantBeGenerated:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_urlCantBeGenerated, completion: completion)
            case .noNetworkConnection:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_noNetworkConnection, completion: completion)
            case .requestTimedOut:
                weakSelf.displayAlert(withTitle: nil, withMessage: AppStrings.error_requestTimedOut, completion: completion)
            case .noDataFound:
                weakSelf.displayAlert(withTitle: AppStrings.error_dataInadequate, withMessage: AppStrings.error_enterRequiredData, completion: completion)
            case .noAuthToken:
                weakSelf.displayAlert(withTitle: AppStrings.error_authTokenNotFound, withMessage: AppStrings.error_authenticationError, actions: [UIAlertAction(title: AppStrings.common_logout, style: .destructive, handler: { action in
                    DispatchQueue.global(qos: .background).async {
                        KeyChainManager.shared.deleteKeyChainData()
                        AppDelegate.shared?.showLoginView()
                    }
                })])
            case .invalidAuthToken:
                weakSelf.displayAlert(withTitle: AppStrings.error_invalidAuthToken, withMessage: AppStrings.error_authenticationError, actions: [UIAlertAction(title: AppStrings.common_logout, style: .destructive, handler: { action in
                    DispatchQueue.global(qos: .background).async {
                        KeyChainManager.shared.deleteKeyChainData()
                        AppDelegate.shared?.showLoginView()
                    }
                })])
            }
        }
    }
    
    /// Display alert using the given parameters
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    func displayAlert(withTitle title: String?,
                      withMessage message: String,
                      actions: [UIAlertAction] = [UIAlertAction](),
                      completion: (()->Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty{
            alert.addAction(UIAlertAction(title: AppStrings.common_ok, style: .default){ _ in
                completion?()
            })
        }else{
            actions.forEach{ alert.addAction($0) }
        }
        self.present(alert, animated: true)
    }
}
