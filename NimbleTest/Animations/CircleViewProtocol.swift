//
//  CircleViewProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation
import UIKit

///Consits of methods to turn views into circle
protocol CircleViewProtocol{

    /// makes given view circular
    /// - Parameter circularView: view to be turned circular
     func turnViewIntoCircularView(forView circularView: UIView)

}

extension CircleViewProtocol where Self: UIViewController{

    func turnViewIntoCircularView(forView circularView: UIView){
        self.view.layoutIfNeeded()
        circularView.layer.cornerRadius = circularView.frame.size.width/2
        circularView.clipsToBounds = true
    }

}
