//
//  LoginViewModel.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation

///ViewModel for login screen
class LoginViewModel{

    ///Boxed Data for the View
    var data: Box<LoginViewData> = Box(LoginViewData(email: TextFieldInput(placeHolder: AppStrings.login_email, text: nil),
                                                     password: TextFieldInput(placeHolder: AppStrings.login_password, text: nil)))

}

struct LoginViewData{

    ///TextFieldInput Model for emailField
    var email: TextFieldInput

    ///TextFieldInput Model for passwordField
    var password: TextFieldInput

    ///returns if login is enabled
    var isLoginEnabled: Bool {
        guard  let email = email.text,
           let password = password.text,
           !email.isEmpty,
           !password.isEmpty else {
            return false
        }
        return true
    }
}

///TextVield Input Data Model
struct TextFieldInput{
    ///placeHolder for the text field
    var placeHolder: String?
    ///text for the text field
    var text: String?
}
