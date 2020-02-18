//
//  TransactionLogsCell.swift
//  MR007
//
//  Created by GreatFeat on 30/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import UIKit

class TransactionLogsCell: UITableViewCell {
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var recordType: UILabel!
    @IBOutlet weak var recordState: UILabel!
    @IBOutlet weak var number: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(data: TransactionLogModel) {
        amount.text = "\(data.amount)"
        let dateValue = data.date.prefix(16)
        date.text = String(dateValue)
        number.text = data.number
        recordState.text = data.record_state
        recordType.text = data.record_type
    }

}
