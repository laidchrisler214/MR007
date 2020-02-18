//
//  RecommendedCell.swift
//  MR007
//
//  Created by GreatFeat on 18/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class RecommendedCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    var platformImage = [#imageLiteral(resourceName: "ptLogo"), #imageLiteral(resourceName: "ptLogo"), #imageLiteral(resourceName: "ttgLogo"), #imageLiteral(resourceName: "agLogo"), #imageLiteral(resourceName: "ggLogo"), #imageLiteral(resourceName: "sbLogo")]
    var platformName = ["PT老虎机", "新PT老虎机", "TTG老虎机", "AG真人", "GG捕鱼", "亿万体育"]
    var hexColors = [0x417DC4, 0xDF9418, 0xD0021B, 0xF58023, 0x002950, 0x417505]
    var hex = HexColorConverter()

    func setCell(newGame: LobbyGameModel, index: Int) {
        gameImage.image = platformImage[index]
        gameLabel.text = platformName[index]
        self.backgroundColor = hex.UIColorFromHex(hexValue: UInt32(hexColors[index]))
    }

}
