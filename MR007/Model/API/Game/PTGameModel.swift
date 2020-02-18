//
//  PTGameModel.swift
//  MR007
//
//  Created by Roger Molas on 27/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

//// API Keys
fileprivate enum PTModel: String {
    case gameCode       = "game_code"
}

class PTGameModel: BaseGameModel {
    var games = [PTGame]()

    override func setGame(model: NSDictionary) {
        super.setGame(model: model)
        self.imageBaseURL = model[GameModel.imageBaseUrl.rawValue] as? String ?? ""
        let gameArray = model[GameModel.games.rawValue] as? NSArray
        let container = NSMutableArray()
        for game in gameArray! {
            let gameModel = PTGame()
            gameModel.baseURL = self.imageBaseURL
            gameModel.useEnglish = true
            gameModel.setGame(model: (game as? NSDictionary)!)
            container.add(gameModel)
        }
        self.games = (container.mutableCopy() as? [PTGame])!
    }
}

// Model per game
class PTGame: BaseGameModel {
    var baseURL     = ""
    var chineseName = ""
    var englishName = ""
    var useEnglish: Bool = false

    override func setGame(model: NSDictionary) {
        // Common property
        self.gameId = model[GameModel.gameId.rawValue] as? String ?? ""
        self.gameType = model[GameModel.gameType.rawValue] as? String ?? ""
        self.gameCode = model[PTModel.gameCode.rawValue] as? String ?? ""

        self.chineseName = model[GameModel.chineseName.rawValue] as? String ?? ""
        self.englishName = model[GameModel.englishName.rawValue] as? String ?? ""

        // Generic property
        self.imageURL = "\(self.baseURL)\(self.gameCode).png"
        self.gameName = (useEnglish) ? self.englishName:self.chineseName
    }
}
