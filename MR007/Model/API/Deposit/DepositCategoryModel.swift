//
//  DepositCategoryModel.swift
//  MR007
//
//  Created by GreatFeat on 16/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

//MARK: API KEYS
fileprivate enum API: String {
    case id       = "id"
    case label    = "label"
    case category = "category"
}

class DepositCategoryModel: NSObject {
    var id       = 0
    var label    = ""
    var category = ""

    func setDepositCategory(data: NSDictionary) {
        self.id = data[API.id.rawValue] as? Int ?? 0
        self.category = data[API.category.rawValue] as? String ?? ""
        self.label = data[API.label.rawValue] as? String ?? ""
    }
}
