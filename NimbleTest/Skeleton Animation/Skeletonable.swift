//
//  Skeletonable.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import UIKit

///Protocol to handle Skeleton Animation
protocol Skeletonable: AnyObject{
    ///returns if the view is enabled for skeleton animation
    var isSkeletonEnabled: Bool {get set}

    ///skeleton gradients in the View
    var skeletonGradients: [CAGradientLayer] {get set}

    ///method starts skeleton animation in views
    func startSkeletonAnimation()

    ///method sets frame for gradients
    func setFrameForGradient()

    ///method sets corner Radius For Skeleton
    func setCornerRadiusForSkeleton()

    ///method removesSkeleton Animation
    func removeSkeletonAnimation()

    ///method adds Gradient to the skeleton
    func addGradient()
}

///Assosiated for stored properties of skeletanable protocol
fileprivate enum SkeletonAssosiatedValues {
    fileprivate static var skeletonable = "skeletonable"
    fileprivate static var gradeints = "skeletonGradients"
}

extension Skeletonable {

    var isSkeletonEnabled: Bool {
        get { objc_getAssociatedObject(self, &SkeletonAssosiatedValues.skeletonable) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &SkeletonAssosiatedValues.skeletonable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }

    var skeletonGradients: [CAGradientLayer] {
        get { objc_getAssociatedObject(self, &SkeletonAssosiatedValues.gradeints) as? [CAGradientLayer] ?? [CAGradientLayer]() }
        set { objc_setAssociatedObject(self, &SkeletonAssosiatedValues.gradeints, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }

}
