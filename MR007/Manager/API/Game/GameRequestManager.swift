//
//  GameRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 24/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case lobby      = "lobby"
    case games      = "lobby/games"
    case loggedIn   = "m/lobby/games"
    case category   = "lobby/games/filter"
    case balance    = "lobby/balance"
}

// API Response Keys
fileprivate enum Response: String {
    case imageBaseUrl   = "imageBaseUrl"
    case games          = "games" // Array of game model
}

class GameRequestManager: APIRequestManager {

    func getPlatformBalance(completionHandler: @escaping(_ user: UserModel?, _ games: NSArray?) -> Void,
                            error: RequestErrorBlock?, param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, lobbyGames: NSArray?) in
            // Null data handling
            guard lobbyGames != nil else {
                completionHandler(user, nil)
                return
            }

            let container = NSMutableArray()
            for game in lobbyGames! {
                let gameModel = LobbyGameModel()
                gameModel.setGame(model: (game as? NSDictionary)!)
                container.add(gameModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)
        }, urlString: API.balance.rawValue, param: param, tag: 0)
        //11 is the filter code for new games
        //check poseidon documentation regarding games
    }

    func getNewGames(completionHandler: @escaping(_ user: UserModel?, _ gameList: NSArray?) -> Void,
                     error: RequestErrorBlock?,
                     param: NSDictionary) {

        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let games = data?["games"] as? NSArray
            let baseURL = data?["img_base_url"] as? String

            // Null data handling
            guard games != nil else {
                completionHandler(user, NSArray())
                return
            }

            let container = NSMutableArray()
            for game in games! {
                let gameModel = GameObjecModel()
                gameModel.baseURL = baseURL!
                gameModel.setGame(model: (game as? NSDictionary)!)
                container.add(gameModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.category.rawValue, param: param, tag: 11)
    }

    func getTopGames(completionHandler: @escaping(_ user: UserModel?, _ gameList: NSArray?) -> Void,
                     error: RequestErrorBlock?,
                     param: NSDictionary) {

        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let games = data?["games"] as? NSArray
            let baseURL = data?["img_base_url"] as? String

            // Null data handling
            guard games != nil else {
                completionHandler(user, NSArray())
                return
            }

            let container = NSMutableArray()
            for game in games! {
                let gameModel = GameObjecModel()
                gameModel.baseURL = baseURL!
                gameModel.setGame(model: (game as? NSDictionary)!)
                container.add(gameModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.category.rawValue, param: param, tag: 12)
    }

    /// Get Category/Lobby (Homepage or Dashboard)
    func getGames(completionHandler: @escaping(_ user: UserModel?, _ gameList: NSArray?) -> Void,
                  error: RequestErrorBlock?,
                  param: NSDictionary) {

        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let games = data?["games"] as? NSArray
            let baseURL = data?["img_base_url"] as? String

            // Null data handling
            guard games != nil else {
                completionHandler(user, NSArray())
                return
            }

            let container = NSMutableArray()
            for game in games! {
                let gameModel = GameObjecModel()
                gameModel.baseURL = baseURL!
                gameModel.setGame(model: (game as? NSDictionary)!)
                container.add(gameModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.category.rawValue, param: param, tag: 0)
    }

    //get SW Games
    func getGamesSW(completionHandler: @escaping(_ user: UserModel?, _ gameList: NSArray?) -> Void,
                  error: RequestErrorBlock?,
                  param: NSDictionary) {

        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let games = data?["games"] as? NSArray
            let baseURL = data?["img_base_url"] as? String

            // Null data handling
            guard games != nil else {
                completionHandler(user, NSArray())
                return
            }

            let container = NSMutableArray()
            for game in games! {
                let gameModel = GameObjecModel()
                gameModel.baseURL = baseURL!
                gameModel.setGame(model: (game as? NSDictionary)!)
                container.add(gameModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.games.rawValue, param: param, tag: 0)
    }

    /// OLD
    /// Get Platforms/Lobby (Homepage or Dashboard)
    func getHomePagePlatforms(completionHandler: @escaping(_ user: UserModel?, _ platforms: [LobbyGameModel]?) -> Void,
                              error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, lobbyGames: NSArray?) in
            // Null data handling
            guard lobbyGames != nil else {
                completionHandler(user, nil)
                return
            }

            var container = [LobbyGameModel]()
            for game in lobbyGames! {
                let gameModel = LobbyGameModel()
                gameModel.setGame(model: (game as? NSDictionary)!)
                container.append(gameModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
             error!(_error)

        }, urlString: API.lobby.rawValue, param: nil, tag: 0)
    }

    /// Get Platforms/Lobby Games (PT) (login not required to get list of games)
    func getPlatformsPT(completionHandler: @escaping(_ user: UserModel?, _ PTGame: PTGameModel?) -> Void,
                        error: RequestErrorBlock?) {
        let param = self.getParam(code: .PT)
        self.getRequest(completionHandler: { (user, ptGames: NSDictionary?) in
            // Null data handling
            guard ptGames != nil else {
                completionHandler(user, nil)
                return
            }

            let ptGameModel = PTGameModel()
            ptGameModel.setGame(model: ptGames!)
            completionHandler(user, ptGameModel)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.games.rawValue, param: param, tag: 0)
    }

    /// Get Platform/Lobby Games (TTG)
    func getPlatformsTTG(completionHandler: @escaping(_ user: UserModel?, _ TTGgame: TTGameModel?) -> Void,
                         error: RequestErrorBlock?) {
        let param = self.getParam(code: .TTG)
        self.getRequest(completionHandler: { (user, ttgGames: NSDictionary?) in
            // Null data handling
            guard ttgGames != nil else {
                completionHandler(user, nil)
                return
            }

            let ttgGameModel = TTGameModel()
            ttgGameModel.setGame(model: ttgGames!)
            completionHandler(user, ttgGameModel)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.games.rawValue, param: param, tag: 0)
    }

    /// Get Platform/Lobby Games (BB)
    func getPlatformsBB(completionHandler: @escaping(_ user: UserModel?, _ BBGames: NSArray?) -> Void,
                        error: RequestErrorBlock?) {
        let param = self.getParam(code: .BB)
        self.getRequest(completionHandler: { (user, bbGames: NSDictionary?) in
            // Null data handling
            guard bbGames != nil else {
                completionHandler(user, nil)
                return
            }

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.games.rawValue, param: param, tag: 0)
    }

    /// Get Platform/Lobby Games (AG) (login required)
    func getPlatformsAG(completionHandler: @escaping(_ user: UserModel?, _ AGGame: AGGameModel?) -> Void,
                        error: RequestErrorBlock?) {
        let param = self.getParam(code: .AG)
        self.getRequest(completionHandler: { (user, agGame: NSDictionary?) in
            // Null data handling
            guard agGame != nil else {
                completionHandler(user, nil)
                return
            }
            let agGameModel = AGGameModel()
            agGameModel.setGame(model: agGame!)
            completionHandler(user, agGameModel)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.loggedIn.rawValue, param: param, tag: 0)
    }

    /// Get Platform/Lobby Games (SB) (login required)
    func getPlatformsSB(completionHandler: @escaping(_ user: UserModel?, _ SBGame: SBGameModel?) -> Void,
                        error: RequestErrorBlock?) {
        let param = self.getParam(code: .SB)
        self.getRequest(completionHandler: { (user, sbGame: NSDictionary?) in
            // Null data handling
            guard sbGame != nil else {
                completionHandler(user, nil)
                return
            }
            let sbGameModel = SBGameModel()
            sbGameModel.setGame(model: sbGame!)
            completionHandler(user, sbGameModel)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.loggedIn.rawValue, param: param, tag: 0)
    }

    /// Get Platform/Lobby Balance
    func getLobbyBalance(completionHandler: @escaping(_ user: UserModel?, _ balance: NSDictionary?) -> Void,
                         error: RequestErrorBlock?) {
        let param = self.getParam(code: .PT)
        self.getRequest(completionHandler: { (user, balance: NSDictionary?) in
            // Null data handling
            guard balance != nil else {
                completionHandler(user, nil)
                return
            }

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.games.rawValue, param: param, tag: 0)
    }

    /// Generate parameter
    fileprivate func getParam(code: GameCode) -> NSDictionary {
        let param = NSMutableDictionary()
        let key = "platform"
        switch code {
        case .PT:
            param.setValue(GameCode.PT.rawValue, forKey: key)
            break
        case .TTG:
            param.setValue(GameCode.TTG.rawValue, forKey: key)
            break
        case .BB:
            param.setValue(GameCode.BB.rawValue, forKey: key)
            break
        case .AG:
            param.setValue(GameCode.AG.rawValue, forKey: key)
            break
        case .SB:
            param.setValue(GameCode.SB.rawValue, forKey: key)
            break
        }
        return param
    }
}
