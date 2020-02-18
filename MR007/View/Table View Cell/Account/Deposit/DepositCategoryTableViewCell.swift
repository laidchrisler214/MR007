//
//  DepositCategoryTableViewCell.swift
//  MR007
//
//  Created by GreatFeat on 16/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(data: DepositCategoryModel) {
        self.categoryLabel.text = data.label
        if data.category == "offline" {
            self.categoryIcon.image = #imageLiteral(resourceName: "offlineDepositIcon")
        } else if data.category == "qq" {
            self.categoryIcon.image = #imageLiteral(resourceName: "qqIcon")
        } else if data.category == "wechat" {
            self.categoryIcon.image = #imageLiteral(resourceName: "weChatIcon")
        } else if data.category == "alipay" {
            self.categoryIcon.image = #imageLiteral(resourceName: "aliPayIcon")
        }
    }

}
