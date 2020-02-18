//
//  NewPTCell.swift
//  MR007
//
//  Created by GreatFeat on 13/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class NewPTCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!

    func setCell(topGame: GameObjecModel) {
        let urlString = "http://media.mr007.co/images/web/games/web/sw/\(topGame.gameCode).jpg"
        gameImage.kf.setImage(with: URL(string: urlString))
        gameLabel.text = topGame.chineseName
    }
}
