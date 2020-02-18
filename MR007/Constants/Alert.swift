//
//  Alert.swift
//  MR007
//
//  Created by Roger Molas on 21/02/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Button: String {
    case ok     = "确定"
    case cancel = "取消"
    case retry  = "重试"
    case logOut = "注销登出"
}

fileprivate enum AlertString: String {
    case logOutMessage      = "是否确定登出"
    case sessionTitle       = "您目前登录已超时，请重新登录"
    case sessionMessage     = "请先登录"
    case notFoundTitle      = "Problem Encounter"
    case notFoundMessage    = "Problem accessing page"
}

/// Global Alert Notifier
class Alert {

    static let globalTint = UIColor(red: 56/225, green: 151/225, blue: 189/225, alpha: 1.0)

    func okButton(action:((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: Button.ok.rawValue, style: .default, handler: action)
    }

    func cancelButton(action:((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: Button.cancel.rawValue, style: .cancel, handler: action)
    }

    func retryButton(action:((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: Button.retry.rawValue, style: .default, handler: action)
    }

    // Logout
    func logOut(action:((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: Button.logOut.rawValue, style: .destructive, handler: action)
    }
}

extension Alert {

    fileprivate func mainApplication () -> AppDelegate {
        let application = UIApplication.shared.delegate
        return (application as? AppDelegate)!
    }

    class func logOutAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: AlertString.logOutMessage.rawValue, preferredStyle: .actionSheet)
        return alert
    }

    class func registrationAlert(title: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        return alert
    }

    class func sessionExpiredAlert () {
        let application = Alert().mainApplication()
        application.globalAlert(title: AlertString.sessionTitle.rawValue, message: AlertString.sessionMessage.rawValue)
        application.sessionExpired()
    }

    class func notFoundAlert () {
        let application = Alert().mainApplication()
        application.globalAlert(title: AlertString.notFoundTitle.rawValue, message: AlertString.notFoundMessage.rawValue)
    }

    class func with(title: String?, message: String?) {
        var myTitle = ""
        var myMessage = ""

        if title != nil {
            myTitle = title!
        }

        if message != nil {
            myMessage = message!
        }

        let application = Alert().mainApplication()
        application.globalAlert(title: myTitle, message: myMessage)
    }
}
