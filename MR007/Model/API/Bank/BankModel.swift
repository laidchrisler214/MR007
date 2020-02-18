//
//  BankModel.swift
//  MR007
//
//  Created by Roger Molas on 23/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum Model: String {
    case id             = "id"
    case cardId         = "card_id"
    case category       = "category"
    case bankName       = "bank_name"
    case accountName    = "account_name"
    case address        = "address"
}

class BankModel: NSObject {
    var bankId      = ""
    var cardId      = ""
    var category    = 0
    var accountName = ""
    var bankName    = ""
    var address     = ""

    func setBank(info: NSDictionary) {
        self.bankId = (info[Model.id.rawValue] as? String ?? "")!
        self.cardId = (info[Model.cardId.rawValue] as? String ?? "")!
        self.category = (info[Model.category.rawValue] as? Int ?? 0)!
        self.accountName = (info[Model.accountName.rawValue] as? String ?? "")!
        self.bankName = (info[Model.bankName.rawValue] as? String ?? "")!
        self.address = (info[Model.address.rawValue] as? String ?? "")!
    }
}
