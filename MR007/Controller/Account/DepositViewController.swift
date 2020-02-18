//
//  DepositViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 01/12/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

fileprivate enum Pay: Int {
    case wechat = 0
    case alipay = 1
    case qq     = 2
    case offline = 3
}

class DepositViewController: UIViewController {
    private var currentActiveAccountPageIdentifiers:[String] = []
    var container = ContainerViewController()

    var methods = [DepositMethodModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.container.changeController(segue: Segue.wechatPay, parent: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainer" {
            self.container = (segue.destination as? ContainerViewController)!
        }
    }

    // MARK: Segmented Index Methods
    @IBAction func accountPageChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case Pay.wechat.hashValue:
            self.container.changeController(segue: Segue.wechatPay, parent: self)
            break

        case Pay.alipay.hashValue:
            self.container.changeController(segue: Segue.aliPay, parent: self)
            break

        case Pay.qq.hashValue:
            self.container.changeController(segue: Segue.qqPay, parent: self)
            break

        case Pay.offline.hashValue:
            self.container.changeController(segue: Segue.offlinePay, parent: self)
            break
        default:
            break
        }
    }
}
