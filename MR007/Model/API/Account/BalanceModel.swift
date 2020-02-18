//
//  BalanceModel.swift
//  MR007
//
//  Created by Roger Molas on 02/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum Model: String {
    case balance    = "balance"
    case currency   = "currency"
}

class BalanceModel: NSObject {
    var balance = ""
    var currency = ""
    var details = ""

    func set(model: NSDictionary) {
        self.balance = model[Model.balance.rawValue] as? String ?? ""
        self.currency = model[Model.currency.rawValue] as? String ?? ""
        self.details = "\(self.balance) \(currency)"
    }
}
