//
//  UILabel+animations.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import UIKit


extension UILabel{
    
    /// method change text With animation
    /// - Parameter text: new text to be set
    func changeTextWithanimation(toText text: String?){
        let animation = CATransition()
        animation.duration = 0.5
        self.layer.add(animation, forKey: nil)
        self.text = text
    }

}
