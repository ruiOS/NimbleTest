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
}

extension LoaderProtocol where Self: UIViewController{

    ///shows hud in main view of ViewController and removes user interaction
    func showHud(){
        //Dismiss previous hud before creating a new hud
        dismissHud()
        self.view.isUserInteractionEnabled = false

        //set new hud
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setRingRadius(18)
        SVProgressHUD.setRingNoTextRadius(18)
        SVProgressHUD.setRingThickness(2.0)
        SVProgressHUD.resetOffsetFromCenter()
        SVProgressHUD.show()

    }

    ///Dismiss hud in main view of ViewController and enables user interaction
    func dismissHud(){
        dismissLoading()
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
    }

    func dismissLoading(){}

}
