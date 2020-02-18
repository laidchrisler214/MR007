//
//  AddBankCell.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class AddBankCell: BaseCell {

    class func getCell(tableView: UITableView) -> AddBankCell {
        var addBankCell: AddBankCell?
        addBankCell = tableView.dequeueReusableCell(withIdentifier: CellType.AddBank.rawValue) as? AddBankCell
        if addBankCell == nil {
            addBankCell = AddBankCell()
        }
        return addBankCell!
    }
}
