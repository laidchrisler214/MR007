//
//  GamesCollectionViewCell.swift
//  MR007
//
//  Created by GreatFeat on 16/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class GamesCollectionViewCell: UICollectionViewCell {

    var urlString = String()
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var launchButton: UIButton!

    func setCell(platformCode: String, model: GameObjecModel) {
        if platformCode == "SW" {
            self.urlString = "http://media.mr007.co/images/web/games/web/sw/\(model.gameCode).jpg"
        } else {
            self.urlString = "http://media.mr007.co/images/h5gs_img/\(platformCode)/\(model.gameCode).png"
        }
        self.image.kf.setImage(with: URL(string: self.urlString))
        self.gameLabel.text = model.chineseName
    }
}
