//
//  TransactionLogRequestManager.swift
//  MR007
//
//  Created by GreatFeat on 30/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum API: String {
    case transactionLog  = "/m/transactions"
}

class TransactionLogRequestManager: APIRequestManager {
    /// Get Transfer Logs
    func getTransactionLogs(completionHandler: @escaping(_ user:UserModel?, _ transactions: TransactionModel?) -> Void,
                          error: RequestErrorBlock?,
                          params: NSDictionary) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let transactionModelObject = TransactionModel()
            transactionModelObject.setTransactions(data: data!)
            completionHandler(user, transactionModelObject)
        }, error: { (_error) in
            error!(_error)
        }, urlString: API.transactionLog.rawValue, param: params, tag: 0)
    }
}
