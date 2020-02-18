//
//  BankDetailsCell.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

class BankDetailsCell: BaseCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var dailyLimitLabel: UILabel!

    var isCurrentSelection: Bool = false
    var currentBank: WithdrawalBankModel? = nil
    var isCurrent: Bool = false // currently selected

    class func getCell(tableView: UITableView) -> BankDetailsCell {
        var bankDetailsCell: BankDetailsCell?
        bankDetailsCell = tableView.dequeueReusableCell(withIdentifier: CellType.BankDetails.rawValue) as? BankDetailsCell
        if bankDetailsCell == nil {
            bankDetailsCell = BankDetailsCell()
        }
        bankDetailsCell?.isUserInteractionEnabled = true
        return bankDetailsCell!
    }

    func set(bank: WithdrawalBankModel) {
        self.lblBankName.text = "\(bank.bankName) (\(bank.accountNumber.suffix(4)))"
        if bank.bankName.lowercased() == "abc" {
            thumbnail.image = #imageLiteral(resourceName: "ABC")
        } else if bank.bankName.lowercased() == "ccb" {
            thumbnail.image = #imageLiteral(resourceName: "CCB")
        } else if bank.bankName.lowercased() == "cmb" {
            thumbnail.image = #imageLiteral(resourceName: "CMB")
        } else if bank.bankName.lowercased() == "icbc" {
            thumbnail.image = #imageLiteral(resourceName: "ICBC")
        }
    }

    func setWithCheckMark(bank: WithdrawalBankModel, isSelected: Bool) {
        self.lblBankName.text = "\(bank.bankName) (\(bank.accountNumber.suffix(4)))"
        if bank.bankName.lowercased() == "abc" {
            thumbnail.image = #imageLiteral(resourceName: "ABC")
        } else if bank.bankName.lowercased() == "ccb" {
            thumbnail.image = #imageLiteral(resourceName: "CCB")
        } else if bank.bankName.lowercased() == "cmb" {
            thumbnail.image = #imageLiteral(resourceName: "CMB")
        } else if bank.bankName.lowercased() == "icbc" {
            thumbnail.image = #imageLiteral(resourceName: "ICBC")
        }

        if isSelected {
            checkMarkImage.isHidden = false
        } else {
            checkMarkImage.isHidden = true
        }
    }

    func setWithThumbnail(model: WithdrawalBankModel) {
        self.lblBankName.text = model.bankName
    }

    func loadUserDefault(key:String)->Any?{
        return UserDefaults.standard.object(forKey: key)
    }
}
