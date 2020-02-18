//
//  BaseBonusModel.swift
//  MR007
//
//  Created by Roger Molas on 13/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
internal enum BonusModel: String {
    case bonusId        = "id"
    case vipBonusId     = "bonus_id"
    case name           = "name"
    case status         = "status"
    case gameId         = "game_id"
    case level          = "lv"
    case bonusName      = "bonus_name"
    case bonusContent   = "bonus_content"
    case bonusRate      = "bonus_rate"
    case minTransfer    = "minimum_transfer"
    case maxBonusMoney  = "maximum_bonus_money"
    case withdrawalMultiple = "withdrawal_multiple"
    case cycle          = "cycle"
    case groupId        = "group_id"
    case groupName      = "group_name"
}

class BaseBonusModel: NSObject {
    var bonusId        = ""
    var vipBonusId     = 0
    var name           = ""
    var status         = ""
    var gameId         = 0
    var level          = ""
    var bonusName      = ""
    var bonusContent   = ""
    var bonusRate      = 0
    var minTransfer    = 0
    var maxBonusMoney  = 0
    var withdrawalMultiple = 0
    var cycle          = ""
    var groupId        = ""
    var groupName      = ""

    var withdrawalMessage = ""
    var minTransferMessage = ""
    var bonusRateMessage = ""
    var maxBonusAmount  = ""

    func set(model: NSDictionary) {
        self.bonusId = model[BonusModel.bonusId.rawValue] as? String ?? ""
        self.vipBonusId = model[BonusModel.vipBonusId.rawValue] as? Int ?? 0

        self.name = model[BonusModel.name.rawValue] as? String ?? ""
        self.status = model[BonusModel.status.rawValue] as? String ?? ""
        self.gameId = model[BonusModel.gameId.rawValue] as? Int ?? -1
        self.level = model[BonusModel.level.rawValue] as? String ?? ""
        self.bonusName = model[BonusModel.bonusName.rawValue] as? String ?? ""
        self.bonusContent = model[BonusModel.bonusContent.rawValue] as? String ?? ""
        self.bonusRate = model[BonusModel.bonusRate.rawValue] as? Int ?? 0
        self.minTransfer = model[BonusModel.minTransfer.rawValue] as? Int ?? 0
        self.maxBonusMoney = model[BonusModel.maxBonusMoney.rawValue] as? Int ?? 0
        self.withdrawalMultiple = model[BonusModel.withdrawalMultiple.rawValue] as? Int ?? 0
        self.cycle = model[BonusModel.cycle.rawValue] as? String ?? ""
        self.groupId = model[BonusModel.groupId.rawValue] as? String ?? ""
        self.groupName = model[BonusModel.groupName.rawValue] as? String ?? ""

        // tmp will done on server side
        self.withdrawalMessage = "本金+红利的\(self.withdrawalMultiple)倍投注额"
        self.minTransferMessage = "￥\(self.minTransfer)"
        self.bonusRateMessage = "\(self.bonusRate)%"
        self.maxBonusAmount = "￥\(self.maxBonusMoney)"
    }
}
