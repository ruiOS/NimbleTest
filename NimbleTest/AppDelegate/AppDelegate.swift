//
//  AppDelegate.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared = UIApplication.shared.delegate as? AppDelegate

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        if let token = KeyChainManager.shared.getString(forKey: .refreshToken),
           !token.isEmpty{
            window?.rootViewController = SurveyListViewController()
        }else{
            window?.rootViewController = LoginViewController()
        }

        window?.makeKeyAndVisible()

        return true
    }

    func showLoginView(){
        DispatchQueue.main.async { [weak self] in
            self?.window?.rootViewController = LoginViewController()
        }
        
    }

}

