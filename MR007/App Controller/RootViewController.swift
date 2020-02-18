//
//  RootViewController.swift
//  MR007
//
//  Created by Roger Molas on 06/03/2017.
//  Copyright © 2017 Greafeat Services Inc. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UITabBarController {
    let viewControllerManager = ViewControllerManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.setValue(true, forKey: "_hidesShadow")
        self.tabBarController?.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBarController?.tabBar.shadowImage = UIImage()

        self.updateTabs()
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.updateTabs),
                                               name: NSNotification.Name(rawValue: LoginNotification.updateUser.rawValue),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.login),
                                               name: NSNotification.Name(rawValue: LoginNotification.login.rawValue),
                                               object: nil)
    }

    func updateTabs() {
        let accountTab = self.tabBar.items?[1]
        let messageTab = self.tabBar.items?[2]
        let user = SharedUserInfo.sharedInstance
        if user.isLogIn() {
            accountTab?.isEnabled = true
            messageTab?.isEnabled = true
        } else {
            accountTab?.isEnabled = false
            messageTab?.isEnabled = false
        }
    }

    func restoreDefault() {
        DispatchQueue.main.async {
            let home = self.viewControllers?[0] as? UINavigationController
            let storyboard = UIStoryboard(name: StoryboardId.main, bundle: nil)
            let homeView = storyboard.instantiateViewController(withIdentifier: StoryboardId.home)
            home?.setViewControllers([homeView], animated: false)
        }
    }

    func login() {
        let login = storyboard?.instantiateViewController(withIdentifier: StoryboardId.login) as? LoginViewController
        login?.setCallBack(callback: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        let navigation = UINavigationController(rootViewController: login!)
        self.present(navigation, animated: true, completion: nil)
    }

    func register() {
        let login = storyboard?.instantiateViewController(withIdentifier: StoryboardId.login) as? LoginViewController
        login?.setCallBack(callback: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        let navigation = UINavigationController(rootViewController: login!)
        self.present(navigation, animated: true, completion: nil)
    }
}

// MARK : UITabBarControllerDelegate
extension RootViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
            case 0:
                self.viewControllerManager.showHome()
                break
            default:
            break
        }
    }
}
