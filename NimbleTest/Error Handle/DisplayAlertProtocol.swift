//
//  DisplayAlertProtocol.swift
//  NimbleTest
//
//  Created by rupesh-6878 on 24/03/22.
//

import UIKit

typealias ErrorHandleRequiredProtcols = UIViewController & DisplayAlertProtocol & LoaderProtocol

protocol DisplayAlertProtocol{}

extension DisplayAlertProtocol where Self: UIViewController{

    /// Display alert using the given parameters
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    ///   - actions: UIAlertActions to be added to alert
    ///   - completion: Block called when no actions are added
    func displayAlert(withTitle title: String?,
                      withMessage message: String,
                      actions: [UIAlertAction] = [UIAlertAction](),
                      completion: (()->Void)? = nil){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.view.endEditing(true)
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if actions.isEmpty{
                alert.addAction(UIAlertAction(title: AppStrings.common_ok, style: .default){ _ in
                    completion?()
                })
            }else{
                actions.forEach{ alert.addAction($0) }
            }
            weakSelf.present(alert, animated: true)
        }
    }

}
