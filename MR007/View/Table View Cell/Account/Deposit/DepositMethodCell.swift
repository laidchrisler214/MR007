//
//  DepositMethodCell.swift
//  MR007
//
//  Created by Roger Molas on 08/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class DepositMethodCell: BaseCell {
    @IBOutlet weak var lblTitle: UILabel!
    var currentMethod: DepositMethodModel? = nil

    class func getCell(tableView: UITableView, indx: IndexPath) -> DepositMethodCell {
        var methodCell: DepositMethodCell?
        methodCell = tableView.dequeueReusableCell(withIdentifier: CellType.Deposit.rawValue, for: indx) as? DepositMethodCell
        return methodCell!
    }

    func set(method: DepositMethodModel) {
        self.lblTitle.text = method.label
        self.currentMethod = method
    }
}
