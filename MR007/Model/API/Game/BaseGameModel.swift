//
//  BaseGameModel.swift
//  MR007
//
//  Created by Roger Molas on 28/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
internal enum GameModel: String {
    case imageBaseUrl   = "img_base_url"
    case games          = "games"
    // Game Array
    case name           = "name"
    case image          = "image"
    case remark         = "remark"
    case gameId         = "game_id"
    case gameType       = "game_type"
    case category       = "category"
    case chineseName    = "chinese_name"
    case englishName    = "english_name"
    case longName       = "long_name"
    case gameDesc       = "game_desc"
    case gameLock       = "game_lock"
}

// Abstract base class of all game model
class BaseGameModel: NSObject {
    var imageBaseURL = ""
    var gameId       = ""
    var gameName     = ""
    var gameType     = ""
    var gameCode     = ""
    var imageURL     = ""
    var remark       = ""
    var longName     = ""
    var gameLink     = ""

    func setGame(model: NSDictionary) {

    }
}
