//
//  RecordCell.swift
//  MR007
//
//  Created by Roger Molas on 23/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class RecordCell: BaseCell {
    @IBOutlet weak var lblTransactionStatus: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblTransactionAmount: UILabel!
    @IBOutlet weak var lblTransactionNumber: UILabel!

    class func getCell(tableView: UITableView, indx: IndexPath) -> RecordCell {
        var recordkCell: RecordCell?
        recordkCell = tableView.dequeueReusableCell(withIdentifier: CellType.Record.rawValue, for: indx) as? RecordCell
        return recordkCell!
    }

    func set(data: HistoryModel) {
        self.lblTransactionStatus.text = data.message
        self.lblTransactionType.text = data.type
        self.lblTransactionDate.text = data.date
        self.lblTransactionAmount.text = "\(data.amount)"
        self.lblTransactionStatus.text = data.message
    }

    func copyData() {
        UIPasteboard.general.string = self.lblTransactionNumber.text
    }
}
