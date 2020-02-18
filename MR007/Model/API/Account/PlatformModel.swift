//
//  PlatformModel.swift
//  MR007
//
//  Created by Roger Molas on 02/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum PModel: String {
    case platformCode   = "platform_code"
    case balance        = "balance"
    case currency       = "currency"
}

class PlatformModel: BaseGameModel {
    var platformCode    = ""
    var balance         = ""
    var currency        = ""
    var details         = ""

    override func setGame(model: NSDictionary) {
        // Common property
        self.gameId = model[GameModel.gameId.rawValue] as? String ?? ""
        self.gameName = model[GameModel.name.rawValue] as? String ?? ""
        self.gameType = model[GameModel.gameType.rawValue] as? String ?? ""
        self.remark = model[GameModel.remark.rawValue] as? String ?? ""
        self.longName = model[GameModel.longName.rawValue] as? String ?? ""
        self.imageURL = model[GameModel.image.rawValue] as? String ?? ""

        self.platformCode = model[PModel.platformCode.rawValue] as? String ?? ""
        print(self.platformCode)
        self.balance = model[PModel.balance.rawValue] as? String ?? ""
        self.currency = model[PModel.currency.rawValue] as? String ?? ""
        self.details = "\(self.balance) \(self.currency)"
    }
}
