//
//  GameModel.swift
//  MR007
//
//  Created by GreatFeat on 20/06/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum APIGame: String {
    case englishName    = "english_name"
    case chineseName    = "chinese_name"
    case gameType       = "game_type"

    case gameCode       = "game_code"
    case gameId         = "game_id"
    case rating         = "rating"
}

enum GamePlatform {
    case PT
    case TTG
}

class GameObjecModel: NSObject {
    var gameId = 0
    var englishName = ""
    var chineseName = ""
    var gameType = 0
    var gameCode = ""
    var baseURL = ""
    var imageURL = ""
    var rating = ""

    func setGame(model: NSDictionary) {
        self.englishName = model[APIGame.englishName.rawValue] as? String ?? ""
        self.gameType = model[APIGame.gameType.rawValue] as? Int ?? 0

        if let theGameCode = model[APIGame.gameCode.rawValue] as? String {
            self.gameCode = theGameCode
        } else {
            let intGameCode = model[APIGame.gameCode.rawValue] as? Int ?? 0
            self.gameCode = String(intGameCode)
        }

        self.chineseName = model[APIGame.chineseName.rawValue] as? String ?? ""

        self.gameId = model[APIGame.gameId.rawValue] as? Int ?? 0
        if gameId != 0 {
            self.imageURL = "\(self.baseURL)\(self.gameId).png"

        } else {
            self.imageURL = "\(self.baseURL)\(self.gameCode).png"
        }

        self.rating = model[APIGame.rating.rawValue] as? String ?? ""
    }
}
