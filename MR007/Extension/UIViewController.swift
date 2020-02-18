//
//  UIViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 23/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum LoginNotification: String {
    case login      = "LogInNotificationKey"
    case logOut     = "LogOutNotificationKey"
    case showLogIn  = "ShowLogInNotificationKey"
    case updateUser = "UpdateUserNotificationKey"
}

fileprivate enum ButtonTitle: String {
    case login = "修改成“登录   | "
    case register = "修改成“注册"
    case logout = "注销登出"
}

extension UIViewController {

    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "NavMenuIcon"))
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }

    func setRightNavigationItem() {
        var target: Any? = nil
        var selector: Selector? = nil
        var title: String? = nil
        let user = SharedUserInfo.sharedInstance
        if user.isLogIn() {
            navigationItem.rightBarButtonItem = nil
            var balance = Double(user.getUserMainBalance())
            balance = round(1000 * balance!) / 1000
            title = "主账户余额 ¥\(String(format: "%.2f", balance!))"
            let userDetails = user.getUserDetails()
            let userLevel = userDetails["user_level"] as? Int ?? 0
            let rightButton: UIBarButtonItem = UIBarButtonItem(title: title,
                                                               style: .plain,
                                                               target: target,
                                                               action: selector)

            let rightButton2: UIBarButtonItem = UIBarButtonItem(title: "等级\(userLevel)",
                style: .plain,
                target: target,
                action: selector)

            let rightButton3: UIBarButtonItem = UIBarButtonItem(title: user.getUserName(),
                                                               style: .plain,
                                                               target: target,
                                                               action: selector)

            navigationItem.setRightBarButtonItems([rightButton, rightButton2, rightButton3], animated: true)

        } else {
            target = self
            title = ButtonTitle.login.rawValue
            selector = #selector(UIViewController.toggleLogIn)
            let rightButtonLogin: UIBarButtonItem = UIBarButtonItem(title: title,
                                                                   style: .plain,
                                                                   target: target,
                                                                   action: selector)

            title = ButtonTitle.register.rawValue
            selector = #selector(UIViewController.toggleRegister)
            let rightButtonRegister: UIBarButtonItem = UIBarButtonItem(title: title,
                                                                       style: .plain,
                                                                       target: target,
                                                                       action: selector)

            navigationItem.rightBarButtonItems = [rightButtonRegister, rightButtonLogin]
        }

    }

    func toggleLogIn () {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotification.login.rawValue), object: self)
    }

    func toggleRegister () {
        UserDefaults.standard.set(true, forKey: Segue.register)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotification.login.rawValue), object: self)
    }

    func toggleLogOut () {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginNotification.logOut.rawValue), object: self)
    }
}
