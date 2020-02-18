//
//  DepositOfflineTableViewCell.swift
//  MR007
//
//  Created by GreatFeat on 19/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class DepositOfflineTableViewCell: UITableViewCell {

    @IBOutlet weak var bankLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(data: BankModel) {
        self.bankLabel.text = data.bankName
    }

}
