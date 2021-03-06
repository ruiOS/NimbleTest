//
//  AppStrings.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import Foundation

/// Struct consisiting of all strings needed in the app
struct AppStrings{

    private init(){}

    @LocalisedString(key: "nimbleTest.ios.login.forgotPassword", comment: "Forgot?")
    static var login_forgotPassword: String

    @LocalisedString(key: "nimbleTest.ios.login.email", comment: "Email")
    static var login_email: String

    @LocalisedString(key: "nimbleTest.ios.login.password", comment: "Password")
    static var login_password: String

    @LocalisedString(key: "nimbleTest.ios.login.error.enterEmail", comment: "Email")
    static var login_error_enterEmail: String

    @LocalisedString(key: "nimbleTest.ios.login.error.enterPassword", comment: "Password")
    static var login_error_enterPassword: String

    @LocalisedString(key: "nimbleTest.ios.login", comment: "Login")
    static var login: String

    @LocalisedString(key: "nimbleTest.ios.common.ok", comment: "Ok")
    static var common_ok: String

    @LocalisedString(key: "nimbleTest.ios.common.logout", comment: "Logout")
    static var common_logout: String

    //Error
    @LocalisedString(key: "nimbleTest.ios.error.title.anErrorOccured", comment: "An Error Occured")
    static var error_anErrorOccured: String

    @LocalisedString(key: "nimbleTest.ios.error.dataInadequate", comment: "Please kindly enter data and try again")
    static var error_dataInadequate: String

    @LocalisedString(key: "nimbleTest.ios.error.title.dataParseError", comment: "DataParse Error")
    static var error_dataParseError: String

    @LocalisedString(key: "nimbleTest.ios.error.title.authTokenNotFound", comment: "Auth Token Not Found")
    static var error_authTokenNotFound: String

    @LocalisedString(key: "nimbleTest.ios.error.authenticationError", comment: "Authentication Error")
    static var error_authenticationError: String

    @LocalisedString(key: "nimbleTest.ios.error.noDataReturned", comment: "No data returned")
    static var error_noDataReturned: String

    @LocalisedString(key: "nimbleTest.ios.error.pleaseTryAgain", comment: "Please try again")
    static var error_pleaseTryAgain: String

    @LocalisedString(key: "nimbleTest.ios.error.urlCantBeGenerated", comment: "Url can't be generated")
    static var error_urlCantBeGenerated: String

    @LocalisedString(key: "nimbleTest.ios.error.noNetworkConnection", comment: "No network connection")
    static var error_noNetworkConnection: String

    @LocalisedString(key: "nimbleTest.ios.error.requestTimedOut", comment: "Request TimedOut")
    static var error_requestTimedOut: String

    @LocalisedString(key: "nimbleTest.ios.error.logoutAndLoginAgain", comment: "Please Kindly Logout And Login Again")
    static var error_logoutAndLoginAgain: String

    @LocalisedString(key: "nimbleTest.ios.error.invalidAuthToken", comment: "Invalid AuthToken")
    static var error_invalidAuthToken: String

    @LocalisedString(key: "nimbleTest.ios.surveyView.today", comment: "Today")
    static var surveyView_today: String

    @LocalisedString(key: "nimbleTest.ios.surveyDetailView.startSurvey", comment: "Start Survey")
    static var surveyDetailView_today: String

}
