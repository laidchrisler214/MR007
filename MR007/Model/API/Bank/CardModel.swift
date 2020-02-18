//
//  CardModel.swift
//  MR007
//
//  Created by Roger Molas on 27/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// Card Model
fileprivate enum Model: String {
    case name   = "accountName"
    case number = "cardNumber"
    case exp    = "exp"
}

class CardModel: NSObject {
    var name    = ""
    var number  = ""
    var expDate = ""

    func setCard(info: NSDictionary) {
        self.name = info[Model.name.rawValue] as? String ?? ""
        self.number = info[Model.number.rawValue] as? String ?? ""
        self.expDate = info[Model.exp.rawValue] as? String ?? ""
    }
}
