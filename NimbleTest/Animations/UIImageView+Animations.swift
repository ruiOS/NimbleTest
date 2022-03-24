//
//  UIImageView+Animations.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import UIKit

extension UIImageView{
    
    /// method transitions image  as crossDissolve animation
    /// - Parameter image: image to be transitioned into
    func crossDissolveTransition(toImage image: UIImage?){
        UIImageView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { [weak self] in
            self?.image = image
        }
    }

}
