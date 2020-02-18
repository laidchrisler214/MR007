//
//  NotificationsModel.swift
//  MR007
//
//  Created by GreatFeat on 01/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum API: String {
    case count = "count"
    case id = "id"
    case title = "title"
    case updateTime = "updateTime"
    case remark = "remark"
}

class NotificationsModel: NSObject {

    var count = 0
    var id = ""
    var title = ""
    var updateTime = ""
    var remark = ""

    func set(model: NSDictionary) {
        self.count = model[API.count.rawValue] as? Int ?? 0
        self.title = model[API.title.rawValue] as? String ?? ""
        self.id = model[API.id.rawValue] as? String ?? ""
        self.updateTime = model[API.updateTime.rawValue] as? String ?? ""
        self.remark = model[API.remark.rawValue] as? String ?? ""
    }
}
