//
//  ViewControllerManager.swift
//  MR007
//
//  Created by Dwaine Alingarog on 28/11/2016.
//  Copyright © 2016 Greafeat Services Inc. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ViewControllerManager {
    static let sharedInstance:ViewControllerManager = ViewControllerManager()

    var root: UIViewController?
    // Tab bar
    fileprivate var home: UIViewController?
    fileprivate var account: UIViewController?
    fileprivate var message: UIViewController?
    fileprivate var customer: UIViewController?

    // Side bar
    fileprivate var vip: UIViewController?
    fileprivate var promotions: UIViewController?
    fileprivate var cooperation: UIViewController?
    fileprivate var aboutUs: UIViewController?
    fileprivate var userInfo: UIViewController?
    fileprivate var changePassword: UIViewController?

    // Others
    fileprivate var setting: UIViewController?

    //mark: Methods
    ///Gets slide view controller parent
    func slideMenuController(viewController:UIViewController) -> SlideMenuController? {
        var slideMenuController: UIViewController? = viewController
        while slideMenuController != nil {
            if slideMenuController is SlideMenuController {
                return slideMenuController as? SlideMenuController
            }
            slideMenuController = slideMenuController?.parent
        }
        return nil
    }

    func setControllers() {
        let storyboard = UIStoryboard(name: StoryboardId.main, bundle: nil)
        self.root = storyboard.instantiateViewController(withIdentifier: StoryboardId.rootView)
        self.home = storyboard.instantiateViewController(withIdentifier: StoryboardId.home)
        self.account = storyboard.instantiateViewController(withIdentifier: StoryboardId.account)
        self.message = storyboard.instantiateViewController(withIdentifier: StoryboardId.messages)
        self.customer = storyboard.instantiateViewController(withIdentifier: StoryboardId.customerService)

        // Side bar
        self.vip = storyboard.instantiateViewController(withIdentifier: StoryboardId.VIPClub)
        self.userInfo = storyboard.instantiateViewController(withIdentifier: StoryboardId.userInfo)
        self.promotions = storyboard.instantiateViewController(withIdentifier: StoryboardId.promotion)
        self.cooperation = storyboard.instantiateViewController(withIdentifier: StoryboardId.VIPClub)
        self.aboutUs = storyboard.instantiateViewController(withIdentifier: StoryboardId.VIPClub)

        self.setting = storyboard.instantiateViewController(withIdentifier: StoryboardId.accountSettings)
        self.changePassword = storyboard.instantiateViewController(withIdentifier: StoryboardId.changePassword)
    }

    func getSlideViewController() -> SlideMenuController {
        self.setControllers()
        //Configure slide menu
        SlideMenuOptions.contentViewDrag = false
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.shadowOpacity = 0.0
        SlideMenuOptions.shadowOffset = CGSize(width: 2.2, height: 0)

        let storyboard = UIStoryboard(name: StoryboardId.main, bundle: nil)
        //Set main view controller, left view controller and right view controller
        let leftViewController = storyboard.instantiateViewController(withIdentifier: StoryboardId.leftMenu)
        //Setup slide view controller
        let slideViewController = SlideMenuController(mainViewController: root!,
                                                      leftMenuViewController: leftViewController)
        return slideViewController
    }

    func resetView(completion:((Void) -> Void)?) {
        (self.root as? RootViewController)?.selectedIndex = 0
        (self.root as? RootViewController)?.restoreDefault()
        (self.root as? RootViewController)?.updateTabs()
        self.showHome()
        if completion != nil {
            completion!()
        }
    }

    func setHomePage(viewController: UIViewController) {
        let homeTab = (self.root as? UITabBarController)?.viewControllers?[0] as? UINavigationController
        homeTab?.setViewControllers([viewController], animated: false)
        self.slideMenuController(viewController: self.root!)?.changeMainViewController(self.root!, close: true)
        (self.root as? RootViewController)?.selectedIndex = 0
    }

    func showHome() {
        self.setHomePage(viewController: self.home!)
    }

    // Left menu controllers
    func showVipClub () {
        setSegue(segueString: "segueToVip") { () in
            self.showHome()
        }
    }

    func showUserInfo() {
        setSegue(segueString: "segueToSettings") { () in
            self.showHome()
        }
    }

    func showPromotions () {
        setSegue(segueString: "segueToPromotions") { () in
            self.showHome()
        }
    }

    func showCooperation() {
        setSegue(segueString: "segueToCooperation") { () in
            self.showHome()
        }
    }
    
    func showChangePassword() {
        self.setHomePage(viewController: self.changePassword!)
    }

//    func showCooperation() {
//        self.setHomePage(viewController: self.cooperation!)
//    }
//
//    func showAboutUs() {
//        self.setHomePage(viewController: self.aboutUs!)
//    }
//
//    func showSettings() {
//        (self.setting as? AccountSettingsViewController)?.isToggleSideBar = true
//        self.setHomePage(viewController: self.setting!)
//    }
    
    func  setSegue(segueString: String, completionHandler: @escaping() -> Void) {
        self.saveUserDefault(item: segueString, key: Segue.segueFromMenu)
        completionHandler()
    }
    
    func saveUserDefault(item:Any ,key:String){
        UserDefaults.standard.set(item, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
