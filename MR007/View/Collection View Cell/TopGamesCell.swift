//
//  TopGamesCell.swift
//  MR007
//
//  Created by GreatFeat on 18/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class TopGamesCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!

    func setCell(topGame: GameObjecModel) {
        let urlString = "http://media.mr007.co/images/h5gs_img/PT/\(topGame.gameCode).png"
        cellImage.kf.setImage(with: URL(string: urlString))
        gameLabel.text = topGame.chineseName
    }
}
