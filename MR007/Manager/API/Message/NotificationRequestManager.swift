//
//  NotificationRequestManager.swift
//  MR007
//
//  Created by GreatFeat on 01/12/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum API: String {
    case messages = "notifications"
}

class NotificationRequestManager: APIRequestManager {
    func requestNotifications(completionHandler: @escaping(_ user: UserModel?, _  messages: [NotificationsModel]? ) -> Void,
                         error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSArray?) in
            var notifications = [NotificationsModel]()
            for object in data! {
                let notif = NotificationsModel()
                notif.set(model: (object as? NSDictionary)!)
                notifications.append(notif)
            }
            completionHandler(user, notifications)
        }, error: { (_error) in
            error!(_error)
        }, urlString: API.messages.rawValue, param: nil, tag: 0)
    }
}
