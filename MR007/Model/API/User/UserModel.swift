//
//  UserModel.swift
//  MR007
//
//  Created by Roger Molas on 15/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

// API Key
fileprivate enum Model: String {
    case loginName  = "login_name"
    case birthday   = "birthday"
    case gender     = "gender"
    case email      = "email"
    case mobile     = "mobile"
    case fullName   = "full_name"
    case agentCode  = "agent_code"
    case level      = "user_level"
    case loginTime  = "last_login_time"
    case lastLogInIp = "last_login_ip"
    case balance    = "balance"
    case currency   = "currency"
}

class UserModel: NSObject {
    var loginName   = ""
    var birthday    = ""
    var gender      = ""
    var email       = ""
    var mobile      = ""
    var fullName    = ""
    var agentCode   = ""
    var lastLogInIp = ""
    var level       = 0
    var loginTime   = ""
    var balance     = ""
    var currency    = ""
    var totalMoney  = ""
    var wallet: WalletModel? = nil
    var userDictionary:NSDictionary? = nil

    func setUser(info: NSDictionary) {
        self.loginName = info[Model.loginName.rawValue] as? String ?? ""
        self.birthday = info[Model.birthday.rawValue] as? String ?? ""
        self.gender = info[Model.gender.rawValue] as? String ?? ""
        self.email = info[Model.email.rawValue] as? String ?? ""
        self.mobile = info[Model.mobile.rawValue] as? String ?? ""
        self.fullName = info[Model.fullName.rawValue] as? String ?? ""
        self.agentCode = info[Model.agentCode.rawValue] as? String ?? ""
        self.loginTime = info[Model.loginTime.rawValue] as? String ?? ""
        self.balance = info[Model.balance.rawValue] as? String ?? ""
        self.currency = info[Model.currency.rawValue] as? String ?? ""
        self.level  = info[Model.level.rawValue] as? Int ?? 0
        self.lastLogInIp = info[Model.lastLogInIp.rawValue] as? String ?? ""
        self.totalMoney = "\(self.balance) \(self.currency)"
        self.setWallet()
        /// reference user dictionary
        self.userDictionary = nil
        self.userDictionary = NSDictionary(dictionary: info)
    }

    // MARK: User Wallet
    func setWallet() {
        let walletInfo = NSDictionary(dictionaryLiteral: (Model.balance.rawValue, self.balance),
                                      (Model.currency.rawValue, self.currency))
        self.wallet = WalletModel()
        wallet?.setWallet(info: walletInfo)
    }
}
