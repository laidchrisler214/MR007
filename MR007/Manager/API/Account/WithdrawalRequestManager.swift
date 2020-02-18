//
//  WithdrawalRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 15/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API
fileprivate enum API: String {
    case bank       = "m/withdraw/bank"
    case withdraw   = "m/withdraw"
    case limit      = "m/withdraw/limit"
}

class WithdrawalRequestManager: APIRequestManager {
    /// Request Bank Binding list
    func requestBankList(completionHandler: @escaping(_ user:UserModel?, _ bankList: NSArray?) -> Void,
                           error: RequestErrorBlock?) {
        self.getRequest(completionHandler: { (user, banks: NSArray?) in
            guard banks != nil else {
                completionHandler(user, [])
                return
            }

            let container = NSMutableArray()
            guard (banks?.count)! != 0 else {
                completionHandler(user, container)
                return
            }
            // Conver response to model
            for bank in banks! {
                let bankModel = WithdrawalBankModel()
                bankModel.setBank(info: (bank as? NSDictionary)!)
                container.add(bankModel)
            }
            completionHandler(user, container)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.bank.rawValue, param: nil, tag: 0)
    }

    //get withdrawla limit
    func getWithdrawalLimit(completionHandler: @escaping(_ user:UserModel?, _ limitData: WithdrawalLimitModel?) -> Void,
                         error: RequestErrorBlock?,
                         param: NSDictionary?) {

        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let limitModel = WithdrawalLimitModel()
            limitModel.setBank(info: data!)
            completionHandler(user, limitModel)
        }, error: { (_error) in
            error!(_error)
        }, urlString: API.limit.rawValue, param: param, tag: 0)
        
    }

    /// Add Bank Binding
    func requestAdd(completionHandler: @escaping(_ user:UserModel?, _ reponse: String?) -> Void,
                           error: RequestErrorBlock?,
                           params: NSDictionary) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString:  API.bank.rawValue, param: params, tag: 0)
    }

    /// Delete Bank Binding
    func requestDelete(completionHandler: @escaping(_ user:UserModel?, _ reponse: String?) -> Void,
                           error: RequestErrorBlock?,
                           params: NSDictionary) {
        self.deleteRequest(completionHandler: { (user, data: NSDictionary?) in
            let message = data?["message"] as? String
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString:  API.bank.rawValue, param: params, tag: 0)
    }

    /// Withdrawal
    func requestWithdrawal(completionHandler: @escaping(_ user:UserModel?, _ reponse: String?) -> Void,
                           error: RequestErrorBlock?,
                           params: NSDictionary) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString:  API.withdraw.rawValue, param: params, tag: 0)
    }
}
