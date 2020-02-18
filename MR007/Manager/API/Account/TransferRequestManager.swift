//
//  TransferRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 13/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case transferIn     = "m/transfer/in"
    case transferOut    = "m/transfer/out"
}

class TransferRequestManager: APIRequestManager {
    /// TransferIn to Platform
    func requestTransferIn(completionHandler: @escaping(_ user:UserModel?, _ reponse: String?) -> Void,
                           error: RequestErrorBlock?,
                           params: NSDictionary) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString:  API.transferIn.rawValue, param: params, tag: 0)
    }

    /// TransferOut to Main Wallet
    func requestTransferOut(completionHandler: @escaping(_ user:UserModel?, _ response: String?) -> Void,
                            error: RequestErrorBlock?,
                            params: NSDictionary) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.transferOut.rawValue, param: params, tag: 0)
    }
}
