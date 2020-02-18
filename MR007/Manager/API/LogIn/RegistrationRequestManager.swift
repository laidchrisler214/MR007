//
//  RegistrationRequestManager.swift
//  MR007
//
//  Created by Roger Molas on 15/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

// API
fileprivate enum API: String {
    case register   = "register"
    case forgot     = "forgot-password"
    case test       = "m/test"
    case change     = "m/change-password"
}

class RegistrationRequestManager: APIRequestManager {
    /// Send registration request
    func sendRequestWith(completionHandler: @escaping(_ user: UserModel?, _ response: String?) -> Void,
                         error: RequestErrorBlock?,
                         param: NSDictionary?) {
        self.postRequest(completionHandler: { (user, info: NSDictionary?, message) in
            let sharedUser = SharedUserInfo.sharedInstance
            sharedUser.updateUserInfo(userInfo: user?.userDictionary)
            sharedUser.updateUserDetail(userInfo: user?.userDictionary)
            sharedUser.updateSecurity(data: info)
            if sharedUser.isLogIn() {
                LoadingView.success(completion: { (complete) in
                    completionHandler(user, message)
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
            error!(_error)

        }, urlString: API.register.rawValue, param: param, tag: 0)
    }

    func changePasswordRequest(completionHandler: @escaping(_ user: UserModel?, _ response: String?) -> Void,
                              error: RequestErrorBlock?,
                              param: NSDictionary?) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)
        }, error: { (_error) in
            error!(_error)
        }, urlString: API.change.rawValue, param: param, tag: 0)
    }

    /// Request password
    func requestPasswordWith(completionHandler: @escaping(_ user: UserModel?, _ userName: String?) -> Void,
                             error: RequestErrorBlock?,
                             param: NSDictionary?) {
        self.getRequest(completionHandler: { (user, data: NSDictionary?) in
            let message = data?["message"] as? String
            Alert.with(title: message, message: nil)

            let dictionary = data?["data"] as? NSDictionary!
            let userName = dictionary?["loginName"]
            completionHandler(user, (userName as? String)!)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.forgot.rawValue, param: param, tag: 0)
    }

    /// Request change password
    func changePasswordWith(completionHandler: @escaping(_ user: UserModel?, _ response: String?) -> Void,
                            error: RequestErrorBlock?,
                             param: NSDictionary?) {
        self.postRequest(completionHandler: { (user, data: NSDictionary?, message) in
            completionHandler(user, message)

        }, error: { (_error) in
            error!(_error)

        }, urlString: API.forgot.rawValue, param: param, tag: 0)
    }

    func broadcastEvent() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotification.updateUser.rawValue), object: nil)
    }
}
