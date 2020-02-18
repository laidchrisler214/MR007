//
//  WithdrawConfirmationCell.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

protocol WithdrawConfirmationDelegate: NSObjectProtocol {
    func didConfirmWith(amount: String)
}

class WithdrawConfirmationCell: BaseCell {
    weak var delegate: WithdrawConfirmationDelegate? = nil
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var btnWithdraw: UIButton!

    class func getCell(tableView: UITableView) -> WithdrawConfirmationCell {
        var confirmCell: WithdrawConfirmationCell?
        confirmCell = tableView.dequeueReusableCell(withIdentifier: CellType.Confirm.rawValue) as? WithdrawConfirmationCell
        if confirmCell == nil {
            confirmCell = WithdrawConfirmationCell()
        }
        confirmCell?.btnWithdraw.addTarget(confirmCell,
                                           action: NSSelectorFromString("didConfirmWithdrawal"),
                                           for: .touchUpInside)
        return confirmCell!
    }

    // Toggle withdraw button
    func didConfirmWithdrawal () {
        self.delegate?.didConfirmWith(amount: amountField.text!)
        self.amountField.text = ""
    }
}

// MARK: - UITextFieldDelegate
extension WithdrawConfirmationCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
