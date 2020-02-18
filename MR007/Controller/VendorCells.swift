//
//  VendorCells.swift
//  MR007
//
//  Created by GreatFeat on 20/09/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class VendorCells: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var gameTypeLabel: UILabel!
//    @IBOutlet weak var longNameLabel: UILabel!

    func set(data: LobbyGameModel) {
        var urlString = String()
        if data.platformCode == "GG" {
            urlString = "http://media.mr007.co/images/web/\(data.platformCode)-platform.png"
        } else if data.platformCode == "SW" {
            urlString = "http://media.mr007.co/images/web/new-pt-platform.png"
        } else if data.platformCode == "SB" {
            urlString = "http://media.mr007.co/images/web/sports-platform.jpg"
        } else {
            urlString = "http://media.mr007.co/images/web/\(data.platformCode)-platform.jpg"
        }
        self.imageView.kf.setImage(with: URL(string: urlString))
//        self.gameTypeLabel.text = data.gameType
//        self.longNameLabel.text = data.longName
    }
}
