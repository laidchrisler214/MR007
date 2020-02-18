//
//  ContainerViewController.swift
//  MR007
//
//  Created by Roger Molas on 06/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    static let shared = ContainerViewController()

    fileprivate var wechat: UIViewController?
    fileprivate var alipay: UIViewController?
    fileprivate var qqPay: UIViewController?
    fileprivate var offline: UIViewController?

    var currentMethod = [DepositMethodModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wechat = storyboard?.instantiateViewController(withIdentifier: StoryboardId.wechatPay) as? WechatPayViewController
        self.alipay = storyboard?.instantiateViewController(withIdentifier: StoryboardId.aliPay) as? AlipayViewController
        self.qqPay = storyboard?.instantiateViewController(withIdentifier: StoryboardId.qqPay) as? QQPayViewController
        self.offline = storyboard?.instantiateViewController(withIdentifier: StoryboardId.offlinePay) as? OfflineDepositViewController

        print("Method: \(currentMethod)")
    }

    func changeController(segue: String, parent: UIViewController) {
        if segue == Segue.wechatPay {
            self.changeAccountPageType(withViewController: wechat!, parentViewController: parent)
            return
        }

        if segue == Segue.aliPay {
            self.changeAccountPageType(withViewController: alipay!, parentViewController: parent)
            return
        }

        if segue == Segue.qqPay {
            self.changeAccountPageType(withViewController: qqPay!, parentViewController: parent)
            return
        }

        if segue == Segue.offlinePay {
             self.changeAccountPageType(withViewController: offline!, parentViewController: parent)
            return
        }
    }

    private func removeAccountPageFromParentViewController() {
        self.wechat?.willMove(toParentViewController: nil)
        self.alipay?.willMove(toParentViewController: nil)
        self.qqPay?.willMove(toParentViewController: nil)
        self.offline?.willMove(toParentViewController: nil)

        self.wechat?.view.removeFromSuperview()
        self.alipay?.view.removeFromSuperview()
        self.qqPay?.view.removeFromSuperview()
        self.offline?.view.removeFromSuperview()

        self.wechat?.removeFromParentViewController()
        self.alipay?.removeFromParentViewController()
        self.qqPay?.removeFromParentViewController()
        self.offline?.removeFromParentViewController()
    }

    private func changeAccountPageType(withViewController:UIViewController, parentViewController: UIViewController) {
        self.removeAccountPageFromParentViewController()
        self.addChildViewController(withViewController)
        withViewController.view.frame = self.view.bounds
        self.view.addSubview(withViewController.view)
        withViewController.didMove(toParentViewController: parentViewController)
    }
}

class EmptySegue: UIStoryboardSegue {
    override func perform() {

    }
}
