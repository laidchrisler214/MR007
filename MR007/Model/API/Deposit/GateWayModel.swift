//
//  GateWayModel.swift
//  MR007
//
//  Created by GreatFeat on 27/06/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
// API Keys
fileprivate enum Model: String {
    case gateWayId   = "id"
    case category   = "category"
    case label      = "label"
}

class GateWayModel: NSObject {
    var gateWayId = ""
    var category  = 0
    var label     = ""

    func setGateWay(data: NSDictionary) {
        self.gateWayId = data[Model.gateWayId.rawValue] as? String ?? ""
        self.category = data[Model.category.rawValue] as? Int ?? 0
        self.label = data[Model.label.rawValue] as? String ?? ""
    }
}
