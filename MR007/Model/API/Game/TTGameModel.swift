//
//  TTGameModel.swift
//  MR007
//
//  Created by Roger Molas on 28/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// Model per game
class TTGameModel: BaseGameModel {
    var imageUrl: String = ""
    var games = [TTGame]()

    override func setGame(model: NSDictionary) {
        self.imageBaseURL = (model.object(forKey: GameModel.imageBaseUrl.rawValue) as? String)!
        let gameArray = model.object(forKey: GameModel.games.rawValue) as? NSArray

        let container = NSMutableArray()
        for game in gameArray! {
            let gameModel = TTGame()
            gameModel.baseURL = self.imageBaseURL
            gameModel.setGame(model: (game as? NSDictionary)!)
            container.add(gameModel)
        }
        self.games = (container.mutableCopy() as? [TTGame])!
    }
}

class TTGame: BaseGameModel {
    var baseURL     = ""
    var category    = ""
    var chineseName = ""
    var englishName = ""
    var gameDesc    = ""

    var useEnglish: Bool = false

    override func setGame(model: NSDictionary) {
        // Common property
        self.gameId = "\(model[GameModel.gameId.rawValue]!)"
        self.gameType = model[GameModel.gameType.rawValue] as? String ?? ""
        self.gameType = model[GameModel.gameType.rawValue] as? String ?? ""
        self.imageURL = "\(self.baseURL)\(self.gameId).png"

        self.category = model[GameModel.category.rawValue] as? String ?? ""
        self.gameDesc = model[GameModel.gameDesc.rawValue] as? String ?? ""
        self.chineseName = model[GameModel.chineseName.rawValue] as? String ?? ""
        self.englishName = model[GameModel.englishName.rawValue] as? String ?? ""

        self.gameName = (useEnglish) ? self.englishName:self.chineseName
    }
}
