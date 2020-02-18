//
//  PlatformRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 02/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case category = "lobby/filter"
    case balance = "m/lobby/balance"
}

class PlatformRequestManager: APIRequestManager {
    func getPlatformCategory(completionHandler: @escaping(_ user:UserModel?, _ platforms: [PlatformModel]) -> Void,
                             error: RequestErrorBlock?,
                             params: NSDictionary) {

        self.getRequest(completionHandler: { (user:UserModel?, platforms: NSArray?) in
            var container = [PlatformModel]()
            for platform in platforms! {
                let platformModel = PlatformModel()
                platformModel.setGame(model: (platform as? NSDictionary)!)
                container.append(platformModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.category.rawValue, param: params, tag: 0)
    }

    /// Request each platform
    func getPlatformDetails(completionHandler: @escaping(_ user:UserModel?, _ platform: PlatformModel) -> Void,
                            error: RequestErrorBlock?,
                            params: NSDictionary) {
        self.getRequest(completionHandler: { (user, platform: NSDictionary?) in
            let platformModel = PlatformModel()
            platformModel.setGame(model: platform!)
            completionHandler(user, platformModel)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.balance.rawValue, param: params, tag: 0)
    }
}
