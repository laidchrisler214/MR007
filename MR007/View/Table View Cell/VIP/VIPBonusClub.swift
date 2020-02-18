//
//  VIPBonusClub.swift
//  MR007
//
//  Created by GreatFeat on 09/05/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class VIPBonusClub: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var condition: UILabel!

    func setBonus(condition: VIPBonusModel) {
        self.titleLabel.text = "领取条件"
        self.amount.text = "最低转账金额：\(condition.minTransfer)"
        self.condition.text = "提存要求：\(condition.minTransferMessage)"
    }

    func setBonus(detail: VIPBonusModel) {
        self.titleLabel.text = "礼包详情"
        self.amount.text = "最高奖金额度：\(detail.maxBonusAmount)"
        self.condition.text = "奖金比例：\(detail.bonusRate)"
    }
}
