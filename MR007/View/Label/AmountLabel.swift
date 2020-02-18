//
//  AmountLabel.swift
//  MR007
//
//  Created by GreatFeat on 04/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class AmountLabel: UILabel {
    override func draw(_ rect: CGRect) {
        let insets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))

        let layer = self.layer

        let bottomBorder = CALayer()
        bottomBorder.borderColor = UIColor.darkGray.cgColor
        bottomBorder.borderWidth = 1.0
        bottomBorder.frame = CGRect(x: -1.0, y: layer.frame.size.height-1, width: layer.frame.size.width, height: 1.0)
        bottomBorder.borderColor = UIColor.black.cgColor
        layer.addSublayer(bottomBorder)
    }
}
