//
//  VIPClubCell.swift
//  MR007
//
//  Created by GreatFeat on 09/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class VIPClubCell: UITableViewCell {
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    var currentBonus:VIPBonusModel? = nil

    func setVIP(bonus: VIPBonusModel) {
        self.levelLabel.text = bonus.bonusName
        self.descLabel.text = "最高奖金额度：\(bonus.maxBonusMoney)"
        self.currentBonus = bonus // reference current bonus
    }
}
