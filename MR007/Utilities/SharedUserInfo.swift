//
//  SharedUserInfo.swift
//  MR007
//
//  Created by Roger Molas on 15/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation

fileprivate enum UserKey: String {
    case tokenKey           = "token"
    case usernameKey        = "login_name"
    case userDetail         = "user_detail"
    case userLevel          = "user_level"

    case userLoginNameKey   = "userLoginName"
    case balanceKey         = "balance"
}

class SharedUserInfo: NSObject {
    static let sharedInstance:SharedUserInfo = SharedUserInfo()
    var userDictionary: NSDictionary? = nil

    func isLogIn() -> Bool {
        if self.getToken() == "" {
            return false
        }
        return true
    }

    func updateUserInfo(userInfo: NSDictionary?) {
        self.userDictionary = userInfo
        let defaults = UserDefaults.standard
        let userName = userInfo?.object(forKey: UserKey.usernameKey.rawValue)!
        defaults.set(userName, forKey: UserKey.usernameKey.rawValue)
        defaults.synchronize()

        self.updateUserDetail(userInfo: userInfo)
    }

    func updateSecurity(data: NSDictionary?) {
        let defaults = UserDefaults.standard
        let token = data?[UserKey.tokenKey.rawValue]!
        defaults.set(token, forKey: UserKey.tokenKey.rawValue)
        defaults.synchronize()
    }

    func updateUserDetail(userInfo: NSDictionary?) {
        let defaults = UserDefaults.standard
        print(userInfo as Any)
        defaults.set(userInfo, forKey: UserKey.userDetail.rawValue)
        defaults.synchronize()
    }

    func getUserDetails() -> NSDictionary {
        let defaults = UserDefaults.standard
        let userInfo = defaults.object(forKey: UserKey.userDetail.rawValue)
        return (userInfo! as? NSDictionary)!
    }

    func getToken() -> String { // Authentication token
        let defaults = UserDefaults.standard
        let token: String? = defaults.object(forKey: UserKey.tokenKey.rawValue) as? String // tmp will change to keychain after
        return token ?? ""
    }

    func getUserLoginName() -> String { // Log in name
        let details = self.getUserDetails()
        let currentUser: String? = details.object(forKey: UserKey.userLoginNameKey.rawValue) as? String
        return currentUser ?? ""
    }

    func getUserMainBalance() -> String { // Mail wallet balance
        let details = self.getUserDetails()
        let balance: String? = details.object(forKey: UserKey.balanceKey.rawValue) as? String
        return balance ?? ""
    }

    /// Forgot password use Only
    func getUserName() -> String { // Log in name
        let defaults = UserDefaults.standard
        let currentUser: String? = defaults.object(forKey: UserKey.usernameKey.rawValue) as? String
        return currentUser ?? ""
    }

    func getUserLevel() -> Int { // Log in name
        let defaults = UserDefaults.standard
        let currentLevel: Int? = defaults.object(forKey: UserKey.userLevel.rawValue) as? Int
        return currentLevel ?? 0
    }

    func setUser(loginName: String?) {
        let defaults = UserDefaults.standard
        defaults.set(loginName, forKey: UserKey.usernameKey.rawValue)
        defaults.synchronize()
    }

    func removeLoginUser() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: UserKey.usernameKey.rawValue)
        defaults.synchronize()
    }
}
