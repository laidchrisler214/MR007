//
//  HomeTableViewCell.swift
//  MR007
//
//  Created by Dwaine Alingarog on 23/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var gameCode: String = ""
    var imgURL: URL? = nil

    /**
     Sets details and image caching for home page cell.
     - Parameter category: object details for cell
     */
    func setWithPlatform(platform: LobbyGameModel) {
        self.titleLabel.text = platform.name
        self.descriptionLabel.text = platform.remark

        self.gameCode = platform.platformCode // Game code

        if platform.image != "" {
            self.categoryImageView.kf.indicatorType = .activity
            self.categoryImageView.kf.setImage(with: URL(string: platform.image))
            self.imgURL = URL(string: platform.image)
        }
    }
}
