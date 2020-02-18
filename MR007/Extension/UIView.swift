//
//  UIView.swift
//  MR007
//
//  Created by Roger Molas on 07/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate let bottomMargin: CGFloat = 10.0
fileprivate let widthMargin: CGFloat = 40.0
fileprivate let leftMargin: CGFloat = 10.0

extension UIView {

    func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let slideInFromLeftTransition = CATransition()
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
        }
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromRight
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }

    func startRotating(duration: Double) {
        let kAnimationKey = "rotation"

        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(Double.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
    }
    func stopRotating() {
        let kAnimationKey = "rotation"

        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }

    func roundTopCornersWith(radius:CGFloat) {
        let bounds = self.bounds
        let size = CGSize(width: bounds.size.width - widthMargin, height: bounds.size.height)
        let origin = CGPoint(x: leftMargin, y: 0)
        let mframe = CGRect(origin: origin, size: size)
        let maskPath = UIBezierPath(roundedRect: mframe,
                                    byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = mframe
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        let frameLayer = CAShapeLayer()
        frameLayer.frame = mframe
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.fillColor = nil
        self.layer.addSublayer(frameLayer)
    }

    func roundBottomCornersWith(radius:CGFloat) {
        let bounds = self.bounds
        let size = CGSize(width: bounds.size.width - widthMargin, height: bounds.size.height - bottomMargin)
        let origin = CGPoint(x: leftMargin, y: 0)
        let mframe = CGRect(origin: origin, size: size)
        let maskPath = UIBezierPath(roundedRect: mframe,
                                    byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight],
                                    cornerRadii: CGSize(width: radius, height: radius))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = mframe
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        let frameLayer = CAShapeLayer()
        frameLayer.frame = mframe
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.fillColor = nil
        self.layer.addSublayer(frameLayer)
    }

    func maskLayer() {
        let bounds = self.bounds
        let size = CGSize(width: bounds.size.width - widthMargin, height: bounds.size.height)
        let origin = CGPoint(x: leftMargin, y: 0)
        let mframe = CGRect(origin: origin, size: size)
        let maskPath = UIBezierPath(roundedRect: mframe,
                                    byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight],
                                    cornerRadii: CGSize(width: 0, height: 0))

        let maskLayer = CAShapeLayer()
        maskLayer.frame = mframe
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        let frameLayer = CAShapeLayer()
        frameLayer.frame = mframe
        frameLayer.path = maskPath.cgPath
        frameLayer.strokeColor = UIColor.clear.cgColor
        frameLayer.fillColor = nil
        self.layer.addSublayer(frameLayer)
    }
}
