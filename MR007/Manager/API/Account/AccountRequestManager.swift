//
//  AccountRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 02/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case account = "m/account"
}

class AccountRequestManager: APIRequestManager {

    let sharedUser = SharedUserInfo.sharedInstance

    /// Get Acount Details (Balance, Platforms)
    func getAccountDetails(completionHandler: @escaping(_ user:UserModel?, _  platforms: [PlatformModel]) -> Void,
                           error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, platforms: NSArray?) in
            var container = [PlatformModel]()
            for platform in platforms! {
                let platformModel = PlatformModel()
                platformModel.setGame(model: (platform as? NSDictionary)!)
                container.append(platformModel)
            }
            self.sharedUser.updateUserInfo(userInfo: user?.userDictionary)
            self.sharedUser.updateUserDetail(userInfo: user?.userDictionary)
            completionHandler(user, container)
        }, error: { (_error) in
            error!(_error)
        }, urlString: API.account.rawValue, param: nil, tag: 0)
    }
}
