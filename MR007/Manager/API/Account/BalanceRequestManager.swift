//
//  BalanceRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 02/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case balance = "m/lobby/balance"
    case account = "/m/account"
}

class BalanceRequestManager: APIRequestManager {
    /// Get User Platform Balance (per platform)
    func getBalance(completionHandler: @escaping(_ user:UserModel?, _  wallet: WalletModel?) -> Void,
                    error: RequestErrorBlock?,
                    param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let walletModel = WalletModel()

            walletModel.setWallet(info: data!)
            completionHandler(user, walletModel)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.balance.rawValue, param: param, tag: 0)
    }
}
