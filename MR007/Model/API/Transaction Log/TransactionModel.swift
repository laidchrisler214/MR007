//
//  TransactionModel.swift
//  MR007
//
//  Created by GreatFeat on 30/10/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum Model: String {
    case transactions = "transactions"
    case filters      = "filters"

    //filters
    case type         = "type"
    case cnLabel      = "cnLabel"
    case enLabel      = "enLabel"

    //transactions
    case no           = "no"
    case amount       = "amount"
    case date         = "date"
    case message      = "message"
    case record_type  = "record_type"
    case record_state = "record_state"
}

class TransactionModel: NSObject {
    var transactionLogs = [TransactionLogModel]()
    var transactionFilters = [TransactionFilterModel]()

    func setTransactions(data: NSDictionary) {
        let filters = data.object(forKey: Model.filters.rawValue) as? [NSDictionary]
        for filter in filters! {
            let filterObject = TransactionFilterModel()
            filterObject.setFilter(filter: filter)
            self.transactionFilters.append(filterObject)
        }

        let transactions = data.object(forKey: Model.transactions.rawValue) as? [NSDictionary]
        for transaction in transactions! {
            let transactionLog = TransactionLogModel()
            transactionLog.setTransactionLog(log: transaction)
            self.transactionLogs.append(transactionLog)
        }
    }
}

class TransactionFilterModel: NSObject {
    var type = 0
    var cnLabel = ""
    var enLabel = ""

    func setFilter(filter: NSDictionary) {
        self.type = (filter[Model.type.rawValue] as? Int ?? 0)!
        self.cnLabel = (filter[Model.cnLabel.rawValue] as? String ?? "")!
        self.enLabel = (filter[Model.enLabel.rawValue] as? String ?? "")!
    }
}

class TransactionLogModel: NSObject {
    var number = ""
    var amount = 0.0
    var date = ""
    var message = ""
    var record_type = ""
    var record_state = ""

    func setTransactionLog(log: NSDictionary) {
        self.number = (log[Model.no.rawValue] as? String ?? "")!
        self.amount = (log[Model.amount.rawValue] as? Double ?? 0.0)!
        self.date = (log[Model.date.rawValue] as? String ?? "")!
        self.message = (log[Model.message.rawValue] as? String ?? "")!
        self.record_type = (log[Model.record_type.rawValue] as? String ?? "")!
        self.record_state = (log[Model.record_state.rawValue] as? String ?? "")!
    }
}
