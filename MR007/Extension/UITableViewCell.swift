//
//  UITableViewCell.swift
//  MR007
//
//  Created by Roger Molas on 02/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    static let defaultCellHeight: CGFloat = 70.0
    static let standardCellHeight: CGFloat = 44.0
    static let buttonCellHeight: CGFloat = 50.0

    func setToRoundedCorner() {
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
    }

    func addActivityIndicator(activity: inout UIActivityIndicatorView) {
        UIGraphicsBeginImageContext(activity.frame.size)
        activity.center = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
        activity.color = UIColor(colorLiteralRed: 36 / 255, green: 101 / 255, blue: 144 / 255, alpha: 1)
        UIGraphicsEndImageContext()
        self.contentView.addSubview(activity)
        activity.hidesWhenStopped = true
        activity.startAnimating()
    }
}
