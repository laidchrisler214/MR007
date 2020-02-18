//
//  SBGameModel.swift
//  MR007
//
//  Created by Roger Molas on 01/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum SBModel: String {
    case url        = "url"
}

// Model per game
class SBGameModel: BaseGameModel {

    override func setGame(model: NSDictionary) {
        self.gameLink = model[SBModel.url.rawValue] as? String ?? ""
    }
}
