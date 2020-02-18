//
//  HistoryRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 23/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case transactions   = "/m/transactions"
}

fileprivate enum RESPONSE: String {
    case filters        = "filters"
    case transactions   = "transactions"
}

class HistoryRequestManager: APIRequestManager {
    /// Transaction Records history
    func getTransactions(completionHandler: @escaping(_ user:UserModel?, _ filters: NSArray?, _ transactions: NSArray? ) -> Void,
                         error: RequestErrorBlock?,
                         params: NSDictionary) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            // filter array
            let filters = NSMutableArray()
            for filter in (data?[RESPONSE.filters.rawValue] as? NSArray)! {
                let filterModel = FilterModel()
                filterModel.set(model: (filter as? NSDictionary)!)
                filters.add(filterModel)
            }

            // transactions array
            let transactions = NSMutableArray()
            for transaction in (data?[RESPONSE.transactions.rawValue] as? NSArray)! {
                let history = HistoryModel()
                history.set(model: (transaction as? NSDictionary)!)
                transactions.add(history)
            }
            completionHandler(user, filters, transactions)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.transactions.rawValue, param: params, tag: 0)
    }
}
