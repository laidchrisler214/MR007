//
//  WithdrawalBankModel.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// Bank Model
fileprivate enum Model: String {
    case id             = "id"
    case bankName       = "bankName"
    case accountName    = "accountName"
    case accountNumber  = "bankAccount"
    case bankBranch     = "bankBranch"
    case remark         = "remark"
}

class WithdrawalBankModel: NSObject {
    var bankId          = ""
    var bankName        = ""
    var accountName     = ""
    var accountNumber   = ""
    var bankBranch      = ""
    var remark          = ""

    func setBank(info: NSDictionary) {
        self.bankId = (info[Model.id.rawValue] as? String ?? "")!
        self.bankName = (info[Model.bankName.rawValue] as? String ?? "")!
        self.accountName = (info[Model.accountName.rawValue] as? String ?? "")!
        self.accountNumber = (info[Model.accountNumber.rawValue] as? String ?? "")!
        self.bankBranch = (info[Model.bankBranch.rawValue] as? String ?? "")!
        self.remark = (info[Model.remark.rawValue] as? String ?? "")!
    }
}
