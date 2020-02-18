//
//  BankCardsCell.swift
//  MR007
//
//  Created by GreatFeat on 04/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class BankCardsCell: UITableViewCell {

    @IBOutlet weak var banksCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setCell(bankCount: Int) {
        self.banksCountLabel.text = "\(String(describing: bankCount))"
    }

}
