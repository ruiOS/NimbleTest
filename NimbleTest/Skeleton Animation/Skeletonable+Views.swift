//
//  Skeletonable+Views.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import UIKit

extension UIPageControl: Skeletonable{
    func setFrameForGradient() {
        skeletonGradients.forEach({$0.frame = CGRect(x: 35, y: 0, width: frame.width-35, height: frame.height)})
    }

}

extension UIButton: Skeletonable{
    func setFrameForGradient() {
        skeletonGradients.forEach({$0.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)})
    }

}

extension UILabel: Skeletonable{

    func addGradient(){
        self.text = nil
        let numberOfSkeletons = skeletonCount()
        for _ in 0 ..< numberOfSkeletons{
            addSingleGradient()
        }
    }

    private func skeletonCount() -> Int{
        switch numberOfLines{
        case 0:
            return max(Int(frame.height/(25)), 1)
        default:
            return numberOfLines
        }

    }

    func setFrameForGradient() {

        let numberofGradients = skeletonGradients.count

        if numberofGradients == 1{
            let gradientHeight = min(frame.height, 20)
            skeletonGradients.forEach({
                $0.frame = CGRect(x: 0, y: frame.height - gradientHeight, width: frame.width, height: gradientHeight)
            })
        }else{
            let multiplier = (frame.height)/CGFloat((13*numberOfLines) - 4)
            var previousGradientTop: CGFloat?
            let skeletonHeight: CGFloat = (9 * multiplier)
            let skeletonSpacing: CGFloat = (4 * multiplier)
            skeletonGradients.forEach({
                let currentTop: CGFloat
                if let previousGradientTop = previousGradientTop{
                    currentTop = previousGradientTop - ( skeletonHeight + skeletonSpacing)
                }else{
                    currentTop = frame.height - skeletonHeight
                }
                $0.frame = CGRect(x: 0, y: currentTop, width: previousGradientTop != nil ? frame.width : frame.width * 0.75, height: skeletonHeight)
                previousGradientTop = currentTop
            })
        }

    }

    func setCornerRadiusForSkeleton(){
        let numberofGradients = skeletonGradients.count
        if numberofGradients == 1{
            setCornerRadiusForSkeleton(forHeight: min(frame.height, 20))
        }else{
            let multiplier = (frame.height)/CGFloat((13*numberOfLines) - 4)
            let skeletonHeight: CGFloat = (9 * multiplier)
            setCornerRadiusForSkeleton(forHeight: skeletonHeight)
        }
    }

}
