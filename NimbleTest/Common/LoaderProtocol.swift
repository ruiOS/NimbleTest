//
//  LoaderProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation
import SVProgressHUD

///Protocol used to handle loader
protocol LoaderProtocol{

    func dismissLoading()

    ///Dismiss hud in main view of ViewController and enables user interaction
    func dismissHud()
}

extension LoaderProtocol where Self: UIViewController{

    ///shows hud in main view of ViewController and removes user interaction
    func showHud(){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            //Dismiss previous hud before creating a new hud
            weakSelf.view.isUserInteractionEnabled = false

            //set new hud
            SVProgressHUD.setContainerView(weakSelf.view)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultAnimationType(.flat)
            SVProgressHUD.setRingRadius(18)
            SVProgressHUD.setRingNoTextRadius(18)
            SVProgressHUD.setRingThickness(2.0)
            SVProgressHUD.resetOffsetFromCenter()
            SVProgressHUD.show()
        }
    }

    func dismissHud(){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissLoading()
            SVProgressHUD.dismiss()
            weakSelf.view.isUserInteractionEnabled = true
        }
    }

    func dismissLoading(){}

}
