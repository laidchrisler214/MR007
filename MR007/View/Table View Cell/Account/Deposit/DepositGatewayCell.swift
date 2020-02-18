//
//  DepositGatewayCell.swift
//  MR007
//
//  Created by GreatFeat on 17/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositGatewayCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var gatewayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(data: GateWayModel, category: String) {
        gatewayLabel.text = data.label
        if category == "qq" {
            self.icon.image = #imageLiteral(resourceName: "qqIcon")
        } else if category == "wechat" {
            self.icon.image = #imageLiteral(resourceName: "weChatIcon")
        } else if category == "alipay" {
            self.icon.image = #imageLiteral(resourceName: "aliPayIcon")
        }
    }

}
