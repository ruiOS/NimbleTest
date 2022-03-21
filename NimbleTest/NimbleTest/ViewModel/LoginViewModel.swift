//
//  LoginViewModel.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation

class LoginViewModel{

    var data: Box<LoginViewData> = Box(LoginViewData(email: TextFieldInput(placeHolder: AppStrings.login_email, text: nil),
                                                     password: TextFieldInput(placeHolder: AppStrings.login_password, text: nil)))

}

struct LoginViewData{

    var email: TextFieldInput
    var password: TextFieldInput

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

struct TextFieldInput{
    var placeHolder: String?
    var text: String?
}
