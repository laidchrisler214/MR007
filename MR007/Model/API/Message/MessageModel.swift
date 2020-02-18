//
//  MessageModel.swift
//  MR007
//
//  Created by GreatFeat on 28/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
// API Keys
fileprivate enum Model: String {
    case status         = "status"
    case messageId      = "message_id"
    case title          = "title"
    case contents       = "contents"
    case receiveId      = "receive_id"
    case createdTime    = "created_time"
}

class MessageModel: NSObject {
    var status         = ""
    var messageId      = ""
    var title          = ""
    var contents       = ""
    var receiveId      = ""
    var createdTime    = ""

    func set(model: NSDictionary) {
        self.status = model[Model.status.rawValue] as? String ?? ""
        self.messageId = model[Model.messageId.rawValue] as? String ?? ""
        self.title = model[Model.title.rawValue] as? String ?? ""
        self.contents = model[Model.contents.rawValue] as? String ?? ""
        self.receiveId = model[Model.receiveId.rawValue] as? String ?? ""
        self.createdTime = model[Model.createdTime.rawValue] as? String ?? ""
    }
}
