//
//  LeftMenuTableViewCell.swift
//  MR007
//
//  Created by Dwaine Alingarog on 23/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlightsLabel: UILabel!

    func setWithIndexPath(indexPath:IndexPath) {

        //Set higlights label design
        self.highlightsLabel.text = ""
        self.highlightsLabel.layer.cornerRadius = 6
        self.highlightsLabel.clipsToBounds = true

        //Set cell details
        switch indexPath.row {
        case LeftMenuType.vip.rawValue:
            self.menuImageView.image = #imageLiteral(resourceName: "DiamondIcon")
            self.titleLabel.text = "VIP 7"
            break
        case LeftMenuType.promotion.rawValue:
            self.menuImageView.image = #imageLiteral(resourceName: "giftIcon")
            self.titleLabel.text = "Promotion"
            highlightsLabel.text = "10"
            break
        case LeftMenuType.cooperation.rawValue:
            self.menuImageView.image = #imageLiteral(resourceName: "coopIcon")
            self.titleLabel.text = "Cooperation"
            break
        case LeftMenuType.about.rawValue:
            self.menuImageView.image = #imageLiteral(resourceName: "errorIcon")
            self.titleLabel.text = "About us"
            break
        default:
            return
        }

    }
}
