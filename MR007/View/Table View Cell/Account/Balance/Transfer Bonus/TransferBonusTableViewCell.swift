//
//  TransferBonusTableViewCell.swift
//  MR007
//
//  Created by GreatFeat on 27/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class TransferBonusTableViewCell: UITableViewCell {

    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func set(data: TransferBonusModel, index: Int, currentIndex: Int) {
        self.bonusLabel.text = data.name
        if currentIndex == index {
            self.checkIcon.isHidden = false
        } else {
            self.checkIcon.isHidden = true
        }
    }

}
