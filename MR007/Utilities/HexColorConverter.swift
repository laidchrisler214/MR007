//
//  HexColorConverter.swift
//  MR007
//
//  Created by GreatFeat on 15/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class HexColorConverter {

    //let navigationColor = UIColor(netHex: 0xf2f2f2)
    let navigationTextColor = UIColor.white

    func UIColorFromHex(hexValue:UInt32, alpha:Double=1.0)-> UIColor {
        let red = CGFloat((hexValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hexValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hexValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
