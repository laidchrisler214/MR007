//
//  PlatformGameCell.swift
//  MR007
//
//  Created by GreatFeat on 04/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class PlatformGameCell: UITableViewCell {

    var urlString = String()
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var englishName: UILabel!
    @IBOutlet weak var chineseName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(platformCode: String, model: GameObjecModel) {
        if platformCode == "SW" {
            self.urlString = "http://media.mr007.co/images/web/games/web/sw/\(model.gameCode).jpg"
        } else {
            self.urlString = "http://media.mr007.co/images/h5gs_img/\(platformCode)/\(model.gameCode).png"
        }
        self.gameImage.kf.setImage(with: URL(string: self.urlString))
        self.chineseName.text = model.chineseName
        self.englishName.text = model.englishName
        self.setStars(rating: model.rating)
    }

    func setStars(rating: String) {
        let value = Double(rating) ?? 0.0

        for i in 0..<Int(value) {
            if i == 0 { star1.image = #imageLiteral(resourceName: "fullStar") }
            if i == 1 { star2.image = #imageLiteral(resourceName: "fullStar") }
            if i == 2 { star3.image = #imageLiteral(resourceName: "fullStar") }
            if i == 3 { star4.image = #imageLiteral(resourceName: "fullStar") }
            if i == 4 { star5.image = #imageLiteral(resourceName: "fullStar") }
        }

        ratingLabel.text = "\(value)"
    }
}
