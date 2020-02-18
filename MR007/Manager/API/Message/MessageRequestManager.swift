//
//  MessageRequestManager.swift
//  MR007
//
//  Created by GreatFeat on 28/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case messages = "m/message"
}

class MessageRequestManager: APIRequestManager {
    /// Get messages
    func requestMessages(completionHandler: @escaping(_ user: UserModel?, _  messages: NSArray?, _ unreadCount: Int?) -> Void,
                         error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let unreadCount = data?["unreadCount"] as? Int
            let messages = NSMutableArray()
            for message in (data?["messages"] as? NSArray)! {
                let messageModel = MessageModel()
                messageModel.set(model: (message as? NSDictionary)!)
                messages.add(messageModel)
            }
            completionHandler(user, messages, unreadCount)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.messages.rawValue, param: nil, tag: 0)
    }

    /// Read message
    func readMessage(completionHandler: @escaping(_ user: UserModel?, _  messages: String?) -> Void,
                     error: RequestErrorBlock?,
                     param: NSDictionary) {
        
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)
        }, error: { (_error) in
            error!(_error)
        }, urlString: API.messages.rawValue, param: param, tag: 0)
    }

    /// Delete message
    func requestDeleteMessage(completionHandler: @escaping(_ user: UserModel?, _  messages: String?) -> Void,
                              error: RequestErrorBlock?,
                              param: NSDictionary) {
        self.deleteRequest(completionHandler: { (user, data: NSDictionary?) in
            completionHandler(user, data?["message"] as? String)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.messages.rawValue, param: param, tag: 0)
    }
}
