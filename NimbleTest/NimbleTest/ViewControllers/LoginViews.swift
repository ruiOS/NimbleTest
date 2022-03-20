//
//  LoginViews.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import UIKit

///Default protocol used for rounded corners in Login View
protocol LoginCorneredViewProtocol{

}

extension LoginCorneredViewProtocol where Self: UIView{
    ///method sets rounded Corners for the view
    /// - Note For best performance call this method in layout subViews
    func setRoundedCorners(){
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}

///TextField used to input emailID
class EmailTextField: PasswordTextField, LoginCorneredViewProtocol{

    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedCorners()
    }

}

///PassPhraseView used to store Forgot Password and password textField
class PassPhraseView: UIView, LoginCorneredViewProtocol{
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedCorners()
    }
}

///SignInButton used to perform signIn
class SignInButton: UIButton, LoginCorneredViewProtocol{
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedCorners()
    }

}

///TextField used to input password
//Change all input rects to change insets
class PasswordTextField: UITextField{
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 19, left: 12, bottom: 15, right: 12))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 19, left: 12, bottom: 15, right: 12))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 19, left: 12, bottom: 15, right: 12))
    }
}
