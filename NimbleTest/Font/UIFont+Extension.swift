//
//  UIFont+Extension.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import UIKit

extension UIFont{

    ///TeextField Font for login View
    static var loginTextFieldFont: UIFont?{
        get{
            return UIFont(name: "NeuzeitSLTStd-Book", size: 18)
        }
    }

    ///PasswordButtonFont for login View
    static var forgotPasswordButtonFont: UIFont?{
        get{
            return UIFont(name: "NeuzeitSLTStd-Book", size: 14)
        }
    }
}
