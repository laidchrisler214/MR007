//
//  FilterModel.swift
//  MR007
//
//  Created by Roger Molas on 23/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Keys
fileprivate enum Model: String {
    case type       = "type"
    case cnLabel    = "cnLabel"
    case enLabel    = "enLabel"
}

class FilterModel: NSObject {
    var type    = 0
    var cnLabel = ""
    var enLabel = ""

    func set(model: NSDictionary) {
        self.type = model[Model.type.rawValue] as? Int ?? 0
        self.cnLabel = model[Model.cnLabel.rawValue] as? String ?? ""
        self.enLabel = model[Model.enLabel.rawValue] as? String ?? ""
    }
}
