//
//  WithdrawalLimitModel.swift
//  MR007
//
//  Created by GreatFeat on 17/11/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// Bank Model
fileprivate enum Model: String {
    case minWithdraw          = "minWithdraw"
    case maxWithdraw          = "maxWithdraw"
    case dailyWithdrawalLimit = "dailyWithdrawalLimit"
}

class WithdrawalLimitModel: NSObject {
    var minWithdraw          = 0
    var maxWithdraw          = 0
    var dailyWithdrawalLimit = 0

    func setBank(info: NSDictionary) {
        self.minWithdraw = info[Model.minWithdraw.rawValue] as? Int ?? 0
        self.maxWithdraw = info[Model.maxWithdraw.rawValue] as? Int ?? 0
        self.dailyWithdrawalLimit = info[Model.dailyWithdrawalLimit.rawValue] as? Int ?? 0
    }
}
