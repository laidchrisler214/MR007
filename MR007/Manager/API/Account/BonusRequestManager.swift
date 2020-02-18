//
//  BonusRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 13/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case transferBonus  = "m/bonus"
    case rescue         = "m/bonus/rescue"
    case VIPLoginBonus  = "m/bonus/vip"
    case VIPBonus       = "bonus/vip"
}

class BonusRequestManager: APIRequestManager {
    /// Get Transfer Bonus
    func getTransferBonus(completionHandler: @escaping(_ user:UserModel?, _ bonusList: NSArray?) -> Void,
                          error: RequestErrorBlock?,
                          params: NSDictionary) {
        self.getRequest(completionHandler: { (user, bonuses: NSArray?) in
            let container = NSMutableArray()
            for bonus in bonuses! {
                let bonusModel = TransferBonusModel()
                bonusModel.set(model: (bonus as? NSDictionary)!)
                container.add(bonusModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.transferBonus.rawValue, param: params, tag: 0)
    }

    /// Get VIP Bonus (Logged In / not Logged In))
    func getVIPBonus(completionHandler: @escaping(_ user:UserModel?, _ bonusList: NSArray?) -> Void,
                          error: RequestErrorBlock?,
                          params: NSDictionary,
                          isLoggedIn:Bool) {
        var urlString = ""
        if isLoggedIn {
            urlString = API.VIPLoginBonus.rawValue
        } else {
            urlString = API.VIPBonus.rawValue
        }
        self.getRequest(completionHandler: { (user, bonuses: NSArray?) in
            guard bonuses != nil else {
                completionHandler(user, NSArray())
                return
            }
            let container = NSMutableArray()
            for bonus in bonuses! {
                let bonusModel = VIPBonusModel()
                bonusModel.set(model: (bonus as? NSDictionary)!)
                container.add(bonusModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: urlString, param: params, tag: 0)
    }

    /// Get Rescue Bonus
    func getRescueBonus(completionHandler: @escaping(_ user:UserModel?, _ response: String?) -> Void,
                        error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let message = data?["message"] as? String
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.rescue.rawValue, param: nil, tag: 0)
    }
}
