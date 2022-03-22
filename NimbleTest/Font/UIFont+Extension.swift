//
//  UIFont+Extension.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import UIKit

extension UIFont{

    ///TextField Font for login View
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

    ///font for survey title
    static var surveyTitleLabelFont: UIFont?{
        get{
            return UIFont(name: "NeuzeitSLTStd-Book", size: 25)
        }
    }

    ///font for survey subtitle
    static var descriptionLabelFont: UIFont?{
        get{
            return UIFont(name: "NeuzeitSLTStd-Book", size: 14)
        }
    }

    ///font for date
    static var dateLabelFont: UIFont?{
        get{
            return UIFont(name: "NeuzeitSLTStd-Book", size: 12)
        }
    }

    ///font for today
    static var todayLabelFont: UIFont?{
        get{
            return UIFont(name: "NeuzeitSLTStd-Book", size: 29)
        }
    }
}
