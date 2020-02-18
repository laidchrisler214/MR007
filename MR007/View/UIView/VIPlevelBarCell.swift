//
//  VIPlevelBarCell.swift
//  MR007
//
//  Created by GreatFeat on 29/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class VIPlevelBarCell: UICollectionViewCell {

    @IBOutlet weak var levelBar: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    let hex = HexColorConverter()

    func setCell(index: Int, currentLevel: Int) {
        levelLabel.text = "\(index)"

        if index <= currentLevel {
            levelBar.backgroundColor = hex.UIColorFromHex(hexValue: 0x0B7DB1)
        } else {
            levelBar.backgroundColor = hex.UIColorFromHex(hexValue: 0xD8D8D8)
        }

        if index == currentLevel {
            levelLabel.backgroundColor = hex.UIColorFromHex(hexValue: 0x0B7DB1)
            levelLabel.textColor = UIColor.white
        } else {
            levelLabel.backgroundColor = UIColor.clear
            levelLabel.textColor = hex.UIColorFromHex(hexValue: 0x0B7DB1)
        }
        levelLabel.layer.masksToBounds = true
        levelLabel.layer.cornerRadius = levelLabel.frame.size.width / 2
    }
}
