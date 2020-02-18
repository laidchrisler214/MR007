//
//  AGGameModel.swift
//  MR007
//
//  Created by Roger Molas on 01/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum AGModel: String {
    case gameLink   = "url"
}

// Model per game
class AGGameModel: BaseGameModel {

    override func setGame(model: NSDictionary) {
        self.gameLink = model[AGModel.gameLink.rawValue] as? String ?? ""
    }
}
