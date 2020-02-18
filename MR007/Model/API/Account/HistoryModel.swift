//
//  HistoryModel.swift
//  MR007
//
//  Created by Roger Molas on 23/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum Model: String {
    case number     = "no"
    case amount     = "amount"
    case date       = "date"
    case message    = "message"
    case type       = "type_string"
}

class HistoryModel: NSObject {
    var amount     = 0
    var number     = ""
    var date       = ""
    var message    = ""
    var type       = ""

    func set(model: NSDictionary) {
        self.amount = model[Model.amount.rawValue] as? Int ?? 0
        self.number = model[Model.number.rawValue] as? String ?? ""
        self.date = model[Model.date.rawValue] as? String ?? ""
        self.message = model[Model.message.rawValue] as? String ?? ""
        self.type = model[Model.type.rawValue] as? String ?? ""
    }
}
