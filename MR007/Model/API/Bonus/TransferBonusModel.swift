//
//  TransferBonusModel.swift
//  MR007
//
//  Created by Roger Molas on 13/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum API: String {
    case id = "id"
    case name = "name"
}

class TransferBonusModel: NSObject {

    var id = 0
    var name = ""

    func set(model: NSDictionary) {
        self.id = model[API.id.rawValue] as? Int ?? 0
        self.name = model[API.name.rawValue] as? String ?? ""
    }
}
