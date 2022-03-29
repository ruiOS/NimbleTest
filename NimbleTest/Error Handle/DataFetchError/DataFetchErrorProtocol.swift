//
//  DataFetchErrorProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import UIKit

protocol DataFetchErrorProtocol{}

extension DataFetchErrorProtocol where Self: ErrorHandleRequiredProtcols{
    
    func handle(dataFetchError: DataFetchError){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dismissHud()
            switch dataFetchError {
            case .invalidAuthToken:
                weakSelf.displayAlert(withTitle: AppStrings.error_invalidAuthToken, withMessage: AppStrings.error_authenticationError, actions: [UIAlertAction(title: AppStrings.common_logout, style: .destructive, handler: { action in
                    DispatchQueue.global(qos: .background).async {
                        KeyChainManager.shared.deleteKeyChainData()
                        AppDelegate.shared?.showLoginView(isWithAnimation: false)
                    }
                })])
            case .dataNotFetched(let message):
                weakSelf.displayAlert(withTitle: nil, withMessage: message)
            }
        }
    }

}
