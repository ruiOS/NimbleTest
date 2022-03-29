//
//  NimbleViewController.swift
//  NimbleTest
//
//  Created by rupesh on 25/03/22.
//

import UIKit

class NimbleViewController: UIViewController{

    let backGroundImageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        tempImageView.contentMode = .scaleAspectFill
        return tempImageView
    }()

    ///adds background image to view and set constraints
    func addBackGroundImageView(asZoomIn isZoomIn: Bool = false){
        self.view.addSubview(backGroundImageView)
        let multiplier: CGFloat = isZoomIn ? 1.2 : 1
        NSLayoutConstraint.activate([
            backGroundImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backGroundImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            backGroundImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: multiplier),
            backGroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: multiplier)
        ])
    }

}
