//
//  MRViewController.swift
//  MR007
//
//  Created by Dwaine Alingarog on 28/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit

class MRViewController: BaseViewController {

    let viewControllerManager:ViewControllerManager = ViewControllerManager.sharedInstance

    enum TabBarType {
        case home
        case account
        case message
        case customerService
    }
}

extension MRViewController: UITabBarDelegate {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
/*
        tabBar.selectedItem = nil

        switch item.tag {
        case TabBarType.home.hashValue:
            self.viewControllerManager.showHome(viewController: self)
            break
        case TabBarType.account.hashValue:
            self.viewControllerManager.showAccount(viewController: self)
            break
        case TabBarType.message.hashValue:
            self.viewControllerManager.showMessages(viewController: self)
            break
        case TabBarType.customerService.hashValue:
            self.viewControllerManager.showCustomerService(viewController: self)
            break
        default:
            break
        }
 */
    }
}
