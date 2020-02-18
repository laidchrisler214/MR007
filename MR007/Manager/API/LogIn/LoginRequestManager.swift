//
//  LoginRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 13/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import PKHUD

// API
fileprivate enum API: String {
    case login   = "login"
    case logout  = "m/logout"
    case test    = "m/test"
}

// API Response Keys
fileprivate enum Response: String {
    case user       = "user"
    case security   = ""
}

class LoginRequestManager : APIRequestManager {
    // MARK: Login
    func sendRequestWith(completionHandler: @escaping(_ user:UserModel?, _  userInfo: NSDictionary?) -> Void,
                         error: RequestErrorBlock?,
                         param: NSDictionary?) {
        LoadingView.logInProgress()
        self.postRequest(completionHandler: { (user, info: NSDictionary?, message) in
            let sharedUser = SharedUserInfo.sharedInstance
            sharedUser.updateUserInfo(userInfo: user?.userDictionary)
            sharedUser.updateUserDetail(userInfo: user?.userDictionary)
            sharedUser.updateSecurity(data: info)
            if sharedUser.isLogIn() {
                LoadingView.success(completion: { (complete) in
                    completionHandler(user, sharedUser.userDictionary)
                    // Broadcast user login
                    self.broadcastEvent()
                })
            } else {
                LoadingView.hide()
                LoadingView.error(completion: { (Void) in
                    error!(nil)
                })
            }
        }, error: { (_error) in
            LoadingView.hide()
            error!(_error)

        }, urlString: API.login.rawValue, param: param, tag: 1)
    }

    // MARK: Logout
    func sendLogoutRequest(completionHandler: @escaping(NSDictionary) -> Void,
                           error: RequestErrorBlock?) {
        LoadingView.nativeProgress()
        self.getRequest(completionHandler: { (user, userInfo: NSDictionary?) in
            let sharedUser = SharedUserInfo.sharedInstance
            sharedUser.updateUserInfo(userInfo: nil)
            sharedUser.updateSecurity(data: nil)

            if !sharedUser.isLogIn() {
                LoadingView.success(completion: { (complete) in
                    completionHandler(userInfo!)
                    // Broadcast user login
                    self.broadcastEvent()
                })
            } else {
                LoadingView.hide()
                LoadingView.hide()
                LoadingView.error(completion: { (Void) in
                    error!(nil)
                })
            }
        }, error: { (_error) in
            LoadingView.hide()
            error!(_error)

        }, urlString: API.logout.rawValue, param: nil, tag: 1)
    }

    func broadcastEvent() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotification.updateUser.rawValue), object: nil)
    }

    /// Unit test
    func tesAutentication() {
        self.apiPOSTRequestWith(finished: { (response) in
            print(response ?? "")
        }, error: { (error) in
            print(error ?? "")
        }, urlString: API.test.rawValue, params: nil, tag: 1)
    }
}
