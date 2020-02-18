//
//  LobbyGameModel.swift
//  MR007
//
//  Created by Roger Molas on 24/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum LBModel: String {
    case gameLock       = "game_lock"
    case image          = "image"
    case longName       = "long_name"
    case name           = "name"
    case platformCode   = "platform_code"
    case remark         = "remark"
    case gameType       = "game_type"
}

// Model per game
class LobbyGameModel: BaseGameModel {
    var gameLock       = ""
    var image          = ""
    var name           = ""
    var platformCode   = ""

    override func setGame(model: NSDictionary) {
        // Common property
        self.gameType = model[GameModel.gameType.rawValue] as? String ?? ""
        self.gameLock = model[LBModel.gameLock.rawValue] as? String ?? ""
        self.image = model[LBModel.image.rawValue] as? String ?? ""
        self.longName = model[LBModel.longName.rawValue] as? String ?? ""
        self.name = model[LBModel.name.rawValue] as? String ?? ""
        self.platformCode = model[LBModel.platformCode.rawValue] as? String ?? ""
        self.remark = model[LBModel.remark.rawValue] as? String ?? ""
    }
}
