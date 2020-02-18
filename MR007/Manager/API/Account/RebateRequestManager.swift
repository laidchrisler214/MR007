//
//  RebateRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 17/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case rebate = "m/rebate"
}

class RebateRequestManager: APIRequestManager {
    /// Request Rebate
    func requestRebate(completionHandler: @escaping(_ user:UserModel?, _ reponse: String?) -> Void,
                       error: RequestErrorBlock?,
                       params: NSDictionary) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let message = data?["message"] as? String
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString:  API.rebate.rawValue, param: params, tag: 0)
    }

    func requestForRebate(completionHandler: @escaping(_ user:UserModel?, _ reponse: NSDictionary?) -> Void,
                       error: RequestErrorBlock?,
                       params: NSDictionary) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            completionHandler(user, data)

        }, error: { (_error) in
            error!(_error)

        }, urlString:  API.rebate.rawValue, param: params, tag: 0)
    }
}
