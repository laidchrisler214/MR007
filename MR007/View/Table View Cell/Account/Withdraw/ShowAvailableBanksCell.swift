//
//  ShowAvailableBanksCell.swift
//  MR007
//
//  Created by GreatFeat on 11/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class ShowAvailableBanksCell: UITableViewCell {

    @IBOutlet weak var bankImage: UIImageView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var bankDetails: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(bankName: String, bankIcon: UIImage) {
        bankImage.image = bankIcon
        self.bankName.text = bankName
    }

}
