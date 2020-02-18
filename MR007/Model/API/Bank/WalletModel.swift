//
//  WalletModel.swift
//  MR007
//
//  Created by Roger Molas on 27/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// Wallet Model
fileprivate enum Model: String {
    case thumbnail      = "thumbnail"
    case balance        = "balance"
    case currency       = "currency"
    case description    = "description"
}

class WalletModel: NSObject {
    var balance             = ""
    var currency            = ""
    var walletDescription   = ""
    var thumbnail: UIImage? = nil
    var details             = ""

    func setWallet(info: NSDictionary) {
//        let imageString = info[Model.thumbnail.rawValue] as? String ?? ""
//        let image = UIImage(named: imageString)
//        self.walletDescription = info[Model.description.rawValue] as? String ?? ""
//        self.thumbnail = image
        self.balance = info[Model.balance.rawValue] as? String ?? ""
        self.currency = info[Model.currency.rawValue] as? String ?? ""
        self.details = "\(balance) \(currency)"
    }
}
