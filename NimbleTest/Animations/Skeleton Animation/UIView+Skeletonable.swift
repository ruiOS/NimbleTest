//
//  UIView+Skeletonable.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import UIKit

extension Skeletonable where Self: UIView{

    
    /// method creates animation group
    /// - Returns: returns newly created animation group
    func getAnimationGroup() -> CAAnimationGroup {

        let animDuration: CFTimeInterval = 1.5

        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor(white: 0.5, alpha: 1).cgColor
        anim1.toValue = UIColor(white: 0.3, alpha: 1).cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor(white: 0.3, alpha: 1).cgColor
        anim2.toValue = UIColor(white: 0.5, alpha: 1).cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false

        return group
    }

    ///starts skeleton animation
    func startSkeletonAnimation(){
        removeSkeletonAnimation()
        addGradient()
        setFrameForGradient()
        setCornerRadiusForSkeleton()
    }

    ///ad Gradients for skeleton animation
    func addGradient(){
        addSingleGradient()
    }

    /// method  asingle gradient to View
    func addSingleGradient(){
        let gradient = CAGradientLayer()
        skeletonGradients.append(gradient)

        if let selfLabel = self as? UILabel{
            selfLabel.inputView?.isHidden = true
        }

        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: self.frame.maxX, y: self.frame.maxX)

        self.layer.addSublayer(gradient)

        let animationGroup = getAnimationGroup()
        animationGroup.beginTime = 0
        gradient.add(animationGroup, forKey: "backgroundColor")
    }

    ///removes skeleton animation
    func removeSkeletonAnimation(){
        self.skeletonGradients.forEach({$0.removeFromSuperlayer()})
        self.skeletonGradients.removeAll()
    }

    ///sets corner radius for skeleton
    func setCornerRadiusForSkeleton(){
        setCornerRadiusForSkeleton(forHeight: frame.height)
    }
    
    /// sets corner radius for skeleton using given height
    /// - Parameter height: aize of the corner radius
    func setCornerRadiusForSkeleton(forHeight height: CGFloat){
        skeletonGradients.forEach({
            $0.cornerRadius = height/2
        })
    }
    
    /// sets frame for gradient
    func setFrameForGradient() {
        skeletonGradients.forEach({
            if frame.height > 20{
                $0.frame = CGRect(x: 0, y: frame.height-20, width: frame.width, height: 20)
            }else{
                $0.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        })
    }

}

extension UIView{
    ///method shows skeleton for all subViews in view
    func showSkeletonForSubViews(){
        self.subviews.forEach({ view in
            autoreleasepool{
                if let skeletonAnimation = view as? Skeletonable, skeletonAnimation.isSkeletonEnabled{
                    skeletonAnimation.startSkeletonAnimation()
                }
            }
        })
    }

    ///method hides skeleton for all subViews in view
    func removeSkeletonAnimationForSubViews(){
        self.subviews.forEach({ view in
            autoreleasepool{
                if let skeletonAnimation = view as? Skeletonable, skeletonAnimation.isSkeletonEnabled{
                    skeletonAnimation.removeSkeletonAnimation()
                }
            }
        })
    }
}

