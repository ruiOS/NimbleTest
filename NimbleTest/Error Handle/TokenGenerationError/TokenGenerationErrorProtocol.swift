//
//  TokenGenerationErrorProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import UIKit

protocol TokenGenerationErrorProtocol{}

extension TokenGenerationErrorProtocol where Self: ErrorHandleRequiredProtcols & NetworkCallErrorProtcol & DataFetchErrorProtocol {

    func handle(tokenGenerationError: TokenGenerationError){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissHud()
            switch tokenGenerationError {
            case .noRefreshTokenAvailable:
                weakSelf.displayAlert(withTitle: AppStrings.error_authTokenNotFound, withMessage: AppStrings.error_authenticationError, actions: [UIAlertAction(title: AppStrings.common_logout, style: .destructive, handler: { action in
                    DispatchQueue.global(qos: .background).async {
                        KeyChainManager.shared.deleteKeyChainData()
                        AppDelegate.shared?.showLoginView(isWithAnimation: false)
                    }
                })])
            case .refreshTokenExpired:
                weakSelf.displayAlert(withTitle: AppStrings.error_invalidAuthToken, withMessage: AppStrings.error_authenticationError, actions: [UIAlertAction(title: AppStrings.common_logout, style: .destructive, handler: { action in
                    DispatchQueue.global(qos: .background).async {
                        KeyChainManager.shared.deleteKeyChainData()
                        AppDelegate.shared?.showLoginView(isWithAnimation: false)
                    }
                })])
            case .networkCallErrorOccured(let error):
                weakSelf.handle(networkCallError: error)
            case .dataFetchErrorOccured(let error):
                weakSelf.handle(dataFetchError: error)
            }
        }
    }

}
